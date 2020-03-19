#!/usr/bin/env nextflow

params.dir = "${baseDir}"
params.threads = 4
params.minReadLength = 2000
params.alignmentReadLength = 1000

fastqFiles = "${params.dir}/**.fastq"
fastqs = Channel.fromPath(fastqFiles).map { path -> tuple(path.baseName, path) }

process filterShortReads {
  tag { sample }
  container "quay.io/biocontainers/dsh-bio:1.3.3--0"

  input:
    set sample, file(fastq) from fastqs
  output:
    set sample, file("${sample}.filtered.fastq.gz") into filtered

  """
  cat ${fastq} \
    | tr ' ' '_' \
    | dsh-bio filter-fastq \
        --length ${params.minReadLength} \
        -o ${sample}.filtered.fastq.gz
  """
}

/*
process filterShortReads {
  tag { sample }
  container "quay.io/glennhickey/pigz:2.3.1" // todo: this docker image has no shell

  input:
    set sample, file(fastq) from fastqs
  output:
    set sample, file("${sample}.filtered.fastq.gz") into filtered

  shell:
  '''
  cat !{fastq} \
    | paste - - - - \
    | tr ' ' '_' \
    | awk 'length($2) > !{params.readLength} { print $1; print $2; print $3; print $4; }' \
    | pigz > !{sample}.filtered.fastq.gz
  '''
}
*/

/*
process minimap2Index {
  tag { sample }
  container "quay.io/biocontainers/minimap2:2.17--h8b12597_1"

  input:
    set sample, file(fastq) from filtered
  output:
    set sample, file(fastq), file("${sample}.mmi") into indexed

  """
  minimap2 -w 1 -d ${sample}.mmi $fastq
  """    
}

process minimap2 {
  tag { sample }
  container "quay.io/biocontainers/minimap2:2.17--h8b12597_1"

  input:
    set sample, file(fastq), file(index) from indexed
  output:
    set sample, file(fastq), file("${sample}.paf") into alignments

  """
  minimap2 -c -w 1 -X -t ${params.threads} -d $index $fastq > ${sample}.paf
  """
}
*/

process minimap2NoIndex {
  tag { sample }
  container "quay.io/biocontainers/minimap2:2.17--h8b12597_1"

  input:
    set sample, file(fastq) from filtered
  output:
    set sample, file(fastq), file("${sample}.paf") into alignments

  """
  minimap2 -c -w 1 -X -t ${params.threads} $fastq $fastq > ${sample}.paf
  """
}

process filterShortAlignments {
  tag { sample }
  container "quay.io/biocontainers/fpa:0.5--hbcae180_2"

  input:
    set sample, file(fastq), file(alignment) from alignments
  output:
    set sample, file(fastq), file("${sample}.filtered.paf") into filteredAlignments

  """
  fpa drop -l ${params.alignmentReadLength} < $alignment > ${sample}.filtered.paf
  """
}

process seqwish {
  tag { sample }
  container "heuermh/seqwish-dev:latest"

  input:
    set sample, file(fastq), file(alignment) from filteredAlignments
  output:
    set sample, file("${sample}.gfa") into graphs

  """
  seqwish -t ${params.threads} -k 16 -s $fastq -p $alignment -g ${sample}.gfa
  """
}

process graphSimplification {
  tag { sample }
  container "heuermh/odgi-dev:latest"

  input:
    set sample, file(graph) from graphs
  output:
    set sample, file("${sample}.odgi-prune.b3.gfa") into simplifiedGraphs

  """
  odgi build -g $graph -o - \
    | odgi prune -i - -b 3 -o - \
    | odgi view -i - -g >${sample}.odgi-prune.b3.gfa
  """

/*
  //container "quay.io/biocontainers/odgi:0.2--py37h8b12597_0"

  """
  odgi build -g $graph -o - \
    | odgi prune -k 16 -i - -o - \
    | odgi view -i - -g >${sample}.odgi-prune.b3.gfa
  """
*/
}

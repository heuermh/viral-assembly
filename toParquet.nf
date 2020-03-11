#!/usr/bin/env nextflow

params.dir = "${baseDir}/PRJNA607948"
params.jar = "https://repo1.maven.org/maven2/com/github/heuermh/adamgfa/adam-gfa_2.11/0.4.0/adam-gfa_2.11-0.4.0.jar"

gfaFiles = "${params.dir}/**.gfa"
gfas = Channel.fromPath(gfaFiles).map { path -> tuple(path.baseName, path.toRealPath().getParent(), path) }
(toDataframe, toDataframes) = gfas.into(2)

process toDataframe {
  tag { sample }
  publishDir "$parent", mode: 'move'
  container "quay.io/biocontainers/adam:0.31.0--0"

  input:
    set sample, parent, file(gfa) from toDataframe
  output:
    set sample, parent, file("${sample}.parquet") into dataframe

  """
  spark-submit ${params.sparkOpts} \
    --conf spark.sql.parquet.compression.codec=gzip \
    --class com.github.heuermh.adam.gfa.Gfa1ToDataframe \
    ${params.jar} \
    $gfa \
    ${sample}.parquet
  """
}

process toDataframes {
  tag { sample }
  publishDir "$parent", mode: 'move'
  container "quay.io/biocontainers/adam:0.31.0--0"

  input:
    set sample, parent, file(gfa) from toDataframes
  output:
    set sample, parent, file("${sample}*.parquet") into dataframes

  """
  spark-submit ${params.sparkOpts} \
    --conf spark.sql.parquet.compression.codec=gzip \
    --class com.github.heuermh.adam.gfa.Gfa1ToDataframes \
    ${params.jar} \
    $gfa \
    ${sample}
  """
}

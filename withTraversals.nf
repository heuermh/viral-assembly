#!/usr/bin/env nextflow

params.dir = "${baseDir}/PRJNA607948"

gfaFiles = "${params.dir}/**.gfa"
gfas = Channel.fromPath(gfaFiles).map { path -> tuple(path.baseName, path.toRealPath().getParent(), path) }

process withTraversals {
  tag { sample }
  publishDir "$parent", mode: 'move'
  container "quay.io/biocontainers/dsh-bio:1.3.3--0"

  input:
    set sample, parent, file(gfa) from gfas
  output:
    set sample, parent, file("${sample}.withTraversals.gfa") into withTraversals

  """
  dsh-bio traverse-paths -i $gfa | dsh-bio truncate-paths -o ${sample}.withTraversals.gfa
  """
}

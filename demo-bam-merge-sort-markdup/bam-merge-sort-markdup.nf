#!/usr/bin/env nextflow

/*
 * Copyright (c) 2019-2021, Ontario Institute for Cancer Research (OICR).
 *                                                                                                               
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * Contributors:
 *   Junjun Zhang <junjun.zhang@oicr.on.ca>
 *   Linda Xiang <linda.xiang@oicr.on.ca>
 */


nextflow.enable.dsl = 2
version = '0.1.11.0'

params.aligned_lane_bams = ""
params.ref_genome_gz = ""
params.aligned_basename = "grch38-aligned.merged"
params.markdup = true
params.output_format = "cram"
params.lossy = false
params.container_version = ""
params.cpus = 1
params.mem = 2  // in GB
params.publish_dir = ""
params.tempdir = ""


process bamMergeSortMarkdup {
  container "quay.io/icgc-argo/bam-merge-sort-markdup:bam-merge-sort-markdup.${params.container_version ?: version}"
  publishDir "${params.publish_dir}/${task.process.replaceAll(':', '_')}",
    mode: "copy",
    enabled: "${params.publish_dir ? true : ''}"

  cpus params.cpus
  memory "${params.mem} GB"


  input:
    path aligned_lane_bams
    path ref_genome_gz
    path ref_genome_gz_secondary_file
    path tempdir

  output:
    path "${params.aligned_basename}.{bam,cram}", emit: merged_seq
    path "${params.aligned_basename}.{bam.bai,cram.crai}", emit: merged_seq_idx
    path "${params.aligned_basename}.duplicates_metrics.tgz", optional: true, emit: duplicates_metrics

  script:
    arg_markdup = params.markdup ? "-d" : ""
    arg_lossy = params.lossy ? "-l" : ""
    arg_tempdir = tempdir.name != 'NO_DIR' ? "-t ${tempdir}" : ""
    """
    bam-merge-sort-markdup.py \
      -i ${aligned_lane_bams} \
      -r ${ref_genome_gz} \
      -n ${params.cpus} \
      -b ${params.aligned_basename} ${arg_markdup} \
      -o ${params.output_format} ${arg_lossy} ${arg_tempdir}
    """
}

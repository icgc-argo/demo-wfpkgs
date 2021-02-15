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
 */


nextflow.enable.dsl=2

params.aligned_lane_bams = ""
params.ref_genome_gz = ""
params.tempdir = "NO_DIR"
params.container_registry = "ghcr.io"


include { bamMergeSortMarkdup } from '../bam-merge-sort-markdup.nf' params(params)
include { getSecondaryFiles } from './wfpr_modules/github.com/icgc-argo/demo-wfpkgs/demo-utils@1.0.0/main.nf'


Channel
  .fromPath(params.aligned_lane_bams, checkIfExists: true)
  .set { aligned_lane_bams_ch }

Channel
  .fromPath(getSecondaryFiles(params.ref_genome_gz, ['fai', 'gzi']), checkIfExists: true)
  .set { ref_genome_gz_idx_ch }


// will not run when import as module
workflow {
  main:
    bamMergeSortMarkdup(
      aligned_lane_bams_ch.collect(),  // all lane bams to be merged
      file(params.ref_genome_gz),
      ref_genome_gz_idx_ch.collect(),
      file(params.tempdir)
    )
}

#!/usr/bin/env nextflow

/*
 * Copyright (c) 2019-2020, Ontario Institute for Cancer Research (OICR).
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

nextflow.preview.dsl = 2

params.seq = ""
params.container_version = ""
params.ref_genome_gz = ""

params.container_registry = ""
params.cpus = 1
params.mem = 2  // in GB


include { alignedSeqQC } from '../aligned-seq-qc.nf' params(params)
include { getSecondaryFiles } from './wfpr_modules/github.com/icgc-argo/demo-wfpkgs/demo-utils@1.0.0/main.nf'

Channel
  .fromPath(params.seq, checkIfExists: true)
  .set { aligned_seq }

Channel
  .fromPath(getSecondaryFiles(params.ref_genome_gz, ['fai', 'gzi']), checkIfExists: true)
  .set { ref_genome_gz_idx }

workflow {
  alignedSeqQC(
    aligned_seq.flatten(),
    file(params.ref_genome_gz),
    ref_genome_gz_idx.collect(),
    true
  )
}

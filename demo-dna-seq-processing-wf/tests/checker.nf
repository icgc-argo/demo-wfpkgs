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


nextflow.enable.dsl = 2

params.lane_bams = "input/?????_?.lane.bam"
params.aligned_lane_prefix = 'grch38-aligned'
params.ref_genome_fa = "reference/tiny-grch38-chr11-530001-537000.fa.gz"
params.metadata = "NO_FILE"
params.tempdir = "NO_DIR"
params.publish_dir = "outdir"

include { DnaSeqProcess } from '../main.nf' params(params)


workflow {
    DnaSeqProcess(
        params.ref_genome_fa,
        params.metadata,
        params.lane_bams,
        params.tempdir
    )
}

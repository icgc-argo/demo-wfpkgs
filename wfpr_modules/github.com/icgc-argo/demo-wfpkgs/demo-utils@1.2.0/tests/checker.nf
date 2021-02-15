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
bwaSecondaryExts = ['fai', 'sa', 'bwt', 'ann', 'amb', 'pac', 'alt']

params.file_name = null
params.file_size = null

include {
    cleanupWorkdir;
    getSecondaryFiles;
    getBwaSecondaryFiles
} from '../main.nf'

include {
    generateDummyFile as gFile1;
    generateDummyFile as gFile2;
} from './generate-dummy-file.nf'

include {
    filesExist as fExist1;
    filesExist as fExist2;
    filesExist as fExist3;
    filesExist as fExist4;
} from './files-exist.nf'

Channel.from(params.file_name).set{ file_name_ch }
Channel.from(bwaSecondaryExts).set{ bwa_ext_ch }


workflow {
    // generate the main file
    gFile1(
        file_name_ch.flatten(),
        params.file_size
    )

    // generate the BWA secondary files
    gFile2(
        file_name_ch.combine(bwa_ext_ch),
        params.file_size
    )

    // test 'getSecondaryFiles' for expected 'fai' file exists
    fExist1(
        getSecondaryFiles(params.file_name, ['fai']),
        'exist',
        gFile2.out.file.collect(),
        true  // no need to wait
    )

    // test 'getBwaSecondaryFiles' for all expected bwa secondary files exist
    fExist2(
        getBwaSecondaryFiles(params.file_name).collect(),
        'exist',
        gFile2.out.file.collect(),
        true  // no need to wait
    )

    // perform cleanup in gFile1 workdir
    cleanupWorkdir(
        gFile1.out.collect(),
        gFile2.out.file.collect()  // flag enables waiting for gFile2 before cleaning up gFile1 workdir
    )

    // test cleaned up workdir from gFile1 indeed does not have previous files
    fExist3(
        gFile1.out.collect(),
        'not_exist',
        gFile1.out.collect(),
        cleanupWorkdir.out  // wait for cleanup is done
    )

    // test not cleaned up workdir from gFile2 indeed still have the exptected files
    fExist4(
        gFile2.out.collect(),
        'exist',
        gFile2.out.collect(),
        cleanupWorkdir.out  // wait for cleanup is done
    )
}

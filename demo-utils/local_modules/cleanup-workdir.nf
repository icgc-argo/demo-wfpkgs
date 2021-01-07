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
version = '1.0.0'

params.cpus = 1
params.mem = 1
params.files_to_delete = 'NO_FILE'
params.container_version = '1.0.0'


process cleanupWorkdir {
    container "docker.pkg.github.com/icgc-argo/demo-wf-pkgs/demo-utils:${params.container_version ?: version}"
    cpus params.cpus
    memory "${params.mem} GB"

    input:
        path files_to_delete  // more accurately, other non-hidden files in the same folder will be deleted as well
        val virtual_dep_flag  // for specifying steps do not produce output files but produce values, set those values here

    output:
        stdout

    script:
        """
        set -euxo pipefail

        IFS=" "
        read -a files <<< "${files_to_delete}"
        for f in "\${files[@]}"
        do
            dir_to_rm=\$(dirname \$(readlink -f \$f))

            if [[ \$dir_to_rm != ${workflow.workDir}/* ]]; then  # skip dir not under workdir, like from input file dir
                echo "Not delete: \$dir_to_rm/*\"
                continue
            fi

            rm -fr \$dir_to_rm/*  # delete all files and subdirs but not hidden ones
            echo "Deleted: \$dir_to_rm/*"
        done
        """
}

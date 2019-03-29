#!/bin/bash
POSITIONAL=()
set -e

function usage() {
    #TODO : rewrite Usage
    printf 'Usage: flux [-b/--bind dirname] [-s/--shell] [-j/--julia filename] [-c commands] \n'
}

singularity="/usr/local/bin/singularity"
flux_img="/opt/singularity/flux-jskim.sif"
cmd="help"
bpath="run"
jlexec="julia --version"
toxexec="tox"
cmexec="ls /mnt"
inname="flux"

while [[ $# -gt 0 ]]
do
    cmd="$1"
    case $cmd in
        -b|--bind)
            bpath="$2"
            shift
            shift
            ;;
        -c|--command)
            cmd="cmd" 
            shift
            cmexec="$@"
            break
            ;;
        -j|--julia)
            cmd="julia"
            jlexec="julia $2"
            shift
            shift
            break
            ;;
        -s|--shell)
            cmd="shell" 
            shift
            break
            ;;
        -t|--test)
            cmd="test"
            toxexec="tox"
            shift
            break
            ;;
        -h|--help)
            cmd="help"
            shift
            break
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

# create directory for mount
mkdir -p ${HOME}/data/${bpath}

case $cmd in
    cmd)
        ${singularity} exec --nv --bind ${HOME}/input:/input,${HOME}/data/${bpath}:/mnt --nv ${flux_img} ${cmexec}
        ;;
    julia) 
        ${singularity} exec --nv --bind ${HOME}/input:/input,${HOME}/data/${bpath}:/mnt --nv ${flux_img} ${jlexec}
        ;;
    shell)
        ${singularity} shell --nv --bind ${HOME}/input:/input,${HOME}/data/${bpath}:/mnt --nv ${flux_img} 
        ;;
    test) 
        ${singularity} exec --nv --bind ${HOME}/input:/input,${HOME}/data/${bpath}:/mnt --nv ${flux_img} ${toxexec}
        ;;
    help)
        usage
        exit 0
        ;;
esac

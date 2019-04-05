#!/usr/bin/env bash
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
testexec=("julia" " --color=yes --project -E " "using Pkg; Pkg.activate(); Pkg.instantiate(); Pkg.test()")
cmexec="ls /mnt"

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
            cmexec="$*"
            break
            ;;
        -j|--julia)
            cmd="julia"
            jlexec="julia --project $2"
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
mkdir -p "${HOME}"/data/"${bpath}"

case $cmd in
    cmd)
        ${singularity} exec --nv --bind "${HOME}"/input:/input,"${HOME}"/data/"${bpath}":/mnt ${flux_img} "${cmexec}"
        ;;
    julia) 
        ${singularity} exec --nv --bind "${HOME}"/input:/input,"${HOME}"/data/"${bpath}":/mnt ${flux_img} "${jlexec}"
        ;;
    shell)
        ${singularity} shell --nv --bind "${HOME}"/input:/input,"${HOME}"/data/"${bpath}":/mnt ${flux_img} 
        ;;
    test) 
        ${singularity} exec --bind "${HOME}"/input:/input,"${HOME}"/data/"${bpath}":/mnt --nv ${flux_img} ${testexec[0]} ${testexec[1]} "${testexec[2]}"
        ;;
    help)
        usage
        exit 0
        ;;
esac

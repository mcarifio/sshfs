#!/usr/bin/env bash
# Mike Carifio <mike@carif.io>

# TODO mike@carif.io: figure out afuse to make this script unnecessary


# exit on error
# set -e



function usage {
    echo <<EOF
-v verbose
-h help
-? help
-d mount all mount points in a directory
EOF
}

function complete {
    echo "bash completion spec tbs"
}

function on_exit {
    :
}

function on_error {
  echo $* > /dev/stderr
  exit 1
}
trap on_exit EXIT

here=$(dirname ${BASH_SOURCE})
me=$(basename ${BASH_SOURCE})

# read default values
[[ -r $0.defaults ]] && source $0.defaults || :


# parse arguments
OPTIND=1
let verbose=0
let usage=0
mounts=${here}/mnt

while getopts "h?v-d:" opt; do
    case "$opt" in
    h|\?)
        usage
        ;;
    v)  let verbose=1
        ;;
    d) mounts=$1
       ;;
    *) shift ${OPTIND}
       on_error "'$1' is not a valid argument"
    esac
done

shift $((OPTIND-1))
[[ "$1" = "--" ]] && shift




if [[ -d $mounts ]] ; then
  for d in ${mounts}/*; do sshfs $(basename ${d}): ${d} || echo "$d already mounted?" ; done
else
  on_error "'${mounts}' is not a directory."
fi





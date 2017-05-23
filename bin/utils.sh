set -o errexit
set -o pipefail
set -o nounset

env_bin=$( echo ${BASH_SOURCE-$_} | xargs dirname )
. ${env_bin}/os.path.sh

get-relpath() {
    local path=$1
    local start=${2-$PWD}
    local pop=

    if [[ "$start" != "$PWD" ]]; then
      pushd $start >/dev/null
      pop=1
    fi

    os.path.relpath $path

    if [ -n "$pop" ]; then
      popd >/dev/null
    fi
}

get-normpath() {
    os.path.normpath "${1-$PWD}"
}

get-abspath() {
    os.path.abspath "${1-$PWD}"
}

get-real-eth-home() {
    local whereisthis=`dirname $BASH_SOURCE`
    local eth_home=`get-abspath "${whereisthis}/.."`
    echo "${eth_home%/}"
}

get-container-dapp-path() {
    local dapp=`get-relpath ${1-$PWD} "${ETH}/dapps"`
    dapp="/var/dapps/${dapp}"
    dapp=`get-normpath "${dapp}"`
    echo ${dapp}
}

test-hookup() {
    echo "Zzzzz hello ${ETH}"
}

get-eth-bins() {
    local find_args
    case "$(uname -s)" in
    Darwin)
        find_args="-perm +111 -type f"
        ;;
    *)
        find_args="-perm /+x -type f"
        ;;
    esac
    for bin in $( find ${ETH}/bin ${find_args} )
    do
        get-relpath "${bin}" "${ETH}/bin"
    done
}

get-run-opts() {
    echo "-w $( get-container-dapp-path ) $@"
}

get-exec-opts() {
    echo "-w $( get-container-dapp-path ) $@"
}

run-docker-compose() {
    pushd ${ETH}/containers >/dev/null
    docker-compose $@
    popd >/dev/null
}

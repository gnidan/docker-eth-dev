set -o errexit
set -o pipefail
set -o nounset

get-relpath() {
    python -c 'import os.path, sys;\
  print os.path.relpath(sys.argv[1],sys.argv[2])' "$1" "${2-$PWD}"
}

get-normpath() {
    python -c 'import os.path, sys;\
  print os.path.normpath(sys.argv[1])' "${1-$PWD}"
}

get-abspath() {
    python -c 'import os.path, sys;\
  print os.path.abspath(sys.argv[1])' "${1-$PWD}"
}

get-real-eth-home() {
    local whereisthis=`dirname $BASH_SOURCE`
    local eth_home=`get-abspath "${whereisthis}/.."`
    echo "${eth_home}"
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

run-docker-compose() {
    pushd ${ETH}/containers >/dev/null
    docker-compose $@
    popd >/dev/null
}

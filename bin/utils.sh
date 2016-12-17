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
    local bins=$(find ${ETH}/bin \
        -perm +111 -type f \
        -exec \
            bash -c 'source ${ETH}/bin/utils.sh && get-relpath "$0" "${ETH}/bin"' {}  \;
    )
    echo "$bins"
}

get-run-opts() {
    eval echo $(cat <<'EOO'
        -w "$( get-container-dapp-path )" \
        $@
EOO)
}


COMPOSE_CFG="${ETH}/containers/docker-compose.yml"

get-docker-compose-cmd() {
    eval echo $(cat <<'EOC'
        /usr/local/bin/docker-compose -f ${COMPOSE_CFG} $@
EOC)
}

activate() {
    # first deactivate to clear anything out
    source ${ETH}/bin/deactivate.sh

    local alias_cmd
    local cmd="source ${ETH}/bin/utils.sh && get-eth-bins"
    local bins="$( bash -c ${cmd} )"

    while read -r bin
    do
        alias_cmd="alias $bin=${ETH}/bin/$bin"
        eval $alias_cmd
    done <<< "${bins}"
}

activate

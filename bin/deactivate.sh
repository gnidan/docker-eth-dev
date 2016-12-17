deactivate() {
    local unalias_cmd
    local cmd="source ${ETH}/bin/utils.sh && get-eth-bins"
    local bins="$( bash -c ${cmd} )"

    while read -r bin
    do
        unalias_cmd="unalias $bin"
        eval $unalias_cmd >/dev/null 2>/dev/null
    done <<< "${bins}"
}

print -n "Deactiving first... "
deactivate
unset ETHACTIVE
echo "gone!"

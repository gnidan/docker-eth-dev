ETH=$( echo $_ | xargs dirname | xargs dirname )   # bootstrap relative ETH

if [ "$ETHACTIVE" -gt "0" ]
then
    # first deactivate to clear anything out
    source ${ETH}/bin/deactivate.sh
fi

activate() {
    local eth_cmd="source $1/bin/utils.sh && get-real-eth-home"
    ETH="$( bash -c ${eth_cmd} )"
    export ETH

    local bins_cmd="source ${ETH}/bin/utils.sh && get-eth-bins"
    local bins="$( bash -c ${bins_cmd} )"

    local alias_cmd
    while read -r bin
    do
        alias_cmd="alias $bin=${ETH}/bin/$bin"
        eval $alias_cmd
    done <<< "${bins}"
}

echo "Activating Ethereum development environment..."
activate "$ETH"
echo "\$ETH set to ${ETH}"

ETHACTIVE=1

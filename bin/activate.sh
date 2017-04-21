# bootstrap relative ETH
ETH=$( echo ${BASH_SOURCE-$_} | xargs dirname | xargs dirname )

if [ "${ETHACTIVE-0}" -gt "0" ]
then
    # first deactivate to clear anything out
    source ${ETH}/bin/deactivate.sh
fi

activate() {
    local eth_cmd=". ${ETH}/bin/utils.sh && get-real-eth-home"
    ETH="$( bash -c "${eth_cmd}" )"
    export ETH

    local bins_cmd=". ${ETH}/bin/utils.sh && get-eth-bins"
    local bins="$( bash -c "${bins_cmd}" )"

    local alias_cmd
    while read -r bin
    do
        alias_cmd="alias $bin=${ETH}/bin/$bin"
        eval $alias_cmd
    done <<< "${bins}"

    echo "ETH=${ETH}" > ${ETH}/containers/.env
}

echo "Activating Ethereum development environment..."
activate
unset activate
echo "\$ETH set to ${ETH}"
pushd ${ETH} >/dev/null

ETHACTIVE=1

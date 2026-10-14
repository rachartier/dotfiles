#!/bin/bash
set -euo pipefail

iface=eth0
presets=(192.168.1.137 192.168.123.137)

out=$(printf '%s\n' "${presets[@]}" | "$HOME/.fzf/bin/fzf" --reverse --height 40% --print-query \
	--prompt "IP> " --header "Pick a preset or type a custom IP" || true)

query=$(sed -n 1p <<<"$out")
choice=$(sed -n 2p <<<"$out")

# A fully typed IP wins over the highlighted preset.
if [[ $query =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	ip=$query
else
	ip=$choice
fi

[[ -n $ip ]] || { echo "No IP selected" >&2; exit 1; }

IFS=. read -ra o <<<"$ip"
for n in "${o[@]}"; do
	((n <= 255)) || { echo "Invalid IP: $ip" >&2; exit 1; }
done

gw="${o[0]}.${o[1]}.${o[2]}.1"

sudo ip addr flush dev "$iface"
sudo ip addr add "$ip/24" dev "$iface"
sudo ip link set "$iface" up
sudo ip route add default via "$gw" dev "$iface"

echo "$iface -> $ip/24 via $gw"

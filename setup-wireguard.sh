#!/usr/bin/env bash
# Sets up a WireGuard VPN server on a fresh Ubuntu 22.04/24.04 or Debian 12 VPS.
# Usage:  sudo bash setup-wireguard.sh
# Result: /root/veil-client.conf  (paste into the Veil app or the WireGuard app)
set -euo pipefail

PORT=51820
SUBNET="10.8.0"

[ "$(id -u)" -eq 0 ] || { echo "Run as root: sudo bash $0"; exit 1; }
[ ! -f /etc/wireguard/wg0.conf ] || { echo "/etc/wireguard/wg0.conf already exists. Aborting so nothing is overwritten."; exit 1; }

apt-get update -y
apt-get install -y wireguard qrencode curl iptables

IFACE=$(ip -4 route get 1.1.1.1 | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}')
PUBIP=$(curl -4 -s https://api.ipify.org)
[ -n "$IFACE" ] && [ -n "$PUBIP" ] || { echo "Could not detect network interface or public IP."; exit 1; }

# Let the server forward traffic
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-wireguard.conf
sysctl --system >/dev/null

umask 077
mkdir -p /etc/wireguard
cd /etc/wireguard
wg genkey | tee server.key | wg pubkey > server.pub
wg genkey | tee client.key | wg pubkey > client.pub
wg genpsk > psk.key

cat > wg0.conf <<EOF
[Interface]
Address = ${SUBNET}.1/24
ListenPort = ${PORT}
PrivateKey = $(cat server.key)
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${IFACE} -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${IFACE} -j MASQUERADE

[Peer]
PublicKey = $(cat client.pub)
PresharedKey = $(cat psk.key)
AllowedIPs = ${SUBNET}.2/32
EOF

cat > /root/veil-client.conf <<EOF
[Interface]
PrivateKey = $(cat client.key)
Address = ${SUBNET}.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = $(cat server.pub)
PresharedKey = $(cat psk.key)
Endpoint = ${PUBIP}:${PORT}
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF
chmod 600 /root/veil-client.conf

# Open the port if ufw is active
if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  ufw allow ${PORT}/udp
fi

systemctl enable --now wg-quick@wg0

echo
echo "Server is running on ${PUBIP}:${PORT}/udp"
echo "Also open UDP ${PORT} in your cloud provider's firewall if it has one."
echo
echo "Client config saved to /root/veil-client.conf. Scan this QR code in the WireGuard app,"
echo "or paste the file's contents into Veil:"
echo
qrencode -t ansiutf8 < /root/veil-client.conf
echo
cat /root/veil-client.conf

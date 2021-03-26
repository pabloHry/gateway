#!/bin/bash

echo "Changement de hostname ..."

cp hostname /etc/hostname
hostname gateway

echo "Le nouveau hostanme : "

hostname

echo "Configuration Network Interface"

cp interfaces /etc/network/

echo "Installation de iptables-persistent"

apt install iptables-persistent -y

echo "Mise en place des iptables"

iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

echo "Sauvegarde la regle"

iptables-save > /etc/iptables/rules.v4

echo "Reload de la carte reseaux"

systemctl restart networking

echo "Changement du dns"

cp resolv.conf /etc/

echo "Activation du Forward d'ip & désactivation de l'ipv6"

cp sysctl.conf /etc/

apt install net-tools -y

sysctl -p

ifconfig

ifup enp0s8

echo "Creation de la clef ssh"

ssh-keygen -t rsa -b 2048

echo "Copie de la clef ssh vers les autres vm"

ssh-copy-id -i ~/.ssh/id_rsa pablo@192.168.0.3
ssh-copy-id -i ~/.ssh/id_rsa pablo@192.168.0.5
ssh-copy-id -i ~/.ssh/id_rsa pablo@192.168.0.10

service ssh restart

ifup enp0s8

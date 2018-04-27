#!/bin/bash

display_message() {
  echo
  echo "$1"
  echo
}

write_message() {

  display_message "$1" > "$2"
  chmod 0644 "$2"
  chown root:root "$2"
}
# Remove Any Old Run Files Left Behind
rm -rf /var/run/*
mkdir -p /var/run/sshd

# Check For Required Variables
[ -z "${USERNAME}" ] && display_message "ERROR: USERNAME Is A Required Environment Variable." && exit 1
[ -z "${PASSWORD}" ] && display_message "ERROR: PASSWORD Is A Required Environment Variable." && exit 1

# Write SSH Keys And Config
[ ! -f /etc/ssh/sshd_config ] && cp /etc/ssh-default/sshd_config /etc/ssh/
chmod 600 /etc/ssh/sshd_config
for KEY in rsa dsa ecdsa
do
  if [ ! -f /etc/ssh/ssh_host_${KEY}_key ]
  then
    rm -f /etc/ssh/ssh_host_${KEY}_key > /dev/null 2>&1
    rm -f /etc/ssh/ssh_host_${KEY}_key.pub > /dev/null 2>&1
    ssh-keygen -f /etc/ssh/ssh_host_${KEY}_key -N '' -t ${KEY}
  fi
  chmod 644 /etc/ssh/ssh_host_${KEY}_key.pub
  chmod 600 /etc/ssh/ssh_host_${KEY}_key
done
ssh-keygen -A
chown root:root /etc/ssh/*

# Build Banner File And Set Any MOTD
if [ ! -f /etc/ssh/banner.txt ]
then
  [ -z "$BANNER" ] &&  BANNER="SSH Docker Container"
  write_message "${BANNER}" "/etc/ssh/banner.txt"
fi
echo "" > /etc/motd
[ -f /etc/ssh/motd.txt ] && cp /etc/ssh/motd.txt /etc/motd
[ ! -z ${MOTD} ] && write_message "${MOTD}" "/etc/motd"

# Configure A Generic SSH User
echo -e -n "${PASSWORD}\n${PASSWORD}\n" | adduser -g "SSH User" -s /bin/bash ${USERNAME}

# Start SSH Service
display_message "Starting OpenSSH..."
/usr/sbin/sshd -D

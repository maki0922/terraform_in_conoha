#!/bin/bash

# Define
####
ROOT_PASSWD="${out_rootpassword}"
MY_USER="${out_username}"
MY_PASS="${out_password}"
HOSTNAME="${out_hostname}"

# Setting root user
#####
echo root:$${ROOT_PASSWD} | /usr/sbin/chpasswd

# Create general user & sudo setting
#####
useradd -m -s /bin/bash "$${MY_USER}"
echo $${MY_USER}:$${MY_PASS} | /usr/sbin/chpasswd
echo "$${MY_USER} ALL=(ALL) NOPASSWD: ALL" | EDITOR="tee -a" visudo

# modify connect setting
mkdir -m 700 -p /home/$${MY_USER}/.ssh
chown $${MY_USER}:$${MY_USER} /home/$${MY_USER}/.ssh

touch /home/$${MY_USER}/.ssh/id_rsa
chmod 600 /home/$${MY_USER}/.ssh/id_rsa
chown $${MY_USER}:$${MY_USER} /home/$${MY_USER}/.ssh/id_rsa

touch /home/$${MY_USER}/.ssh/authorized_keys
chmod 644 /home/$${MY_USER}/.ssh/authorized_keys
chown $${MY_USER}:$${MY_USER} /home/$${MY_USER}/.ssh/authorized_keys

cat << EOF > /home/$${MY_USER}/.ssh/id_rsa
${out_id_rsa}
EOF

cat << EOF > /home/$${MY_USER}/.ssh/authorized_keys
${out_pub_key}
EOF

# Disable Root Permission
#####
sed -e "s/PermitRootLogin yes/PermitRootLogin no/g" -i /etc/ssh/sshd_config
sed -e "s/#PermitRootLogin yes/PermitRootLogin no/g" -i /etc/ssh/sshd_config
sed -e "s/#PermitRootLogin no/PermitRootLogin no/g" -i /etc/ssh/sshd_config
systemctl restart sshd.service

# Package upgrade
#####
apt update
apt install python-pip
pip install ansible

# Extra
#####
hostname $${HOSTNAME}
echo -e "`ip addr show eth0 | grep "inet\s" | awk '{print $2}' | awk -F/ '{print $1}'`\tazuki-vps" >> /etc/hosts

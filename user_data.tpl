#!/bin/bash

# Define
####
ROOT_PASSWD="${out_rootpassword}"

MY_USER="${out_username}"
MY_PASS="${out_password}"

# Setting root user
#####

echo root:$${ROOT_PASSWD} | /usr/sbin/chpasswd

# create general user & sudo setting
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

#sed -e "s/PermitRootLogin yes/PermitRootLogin no/g" -i /etc/ssh/sshd_config
#sed -e "s/#PermitRootLogin yes/PermitRootLogin no/g" -i /etc/ssh/sshd_config
#sed -e "s/#PermitRootLogin no/PermitRootLogin no/g" -i /etc/ssh/sshd_config

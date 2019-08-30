#!/bin/bash

#check for private key for vm-vm comm
[ -f /vagrant/id_rsa ] || {
  ssh-keygen -t rsa -f /vagrant/id_rsa -q -N ''
}
#deploy key
[ -f /home/vagrant/.ssh/id_rsa ] || {
    cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
    chmod 0600 /home/vagrant/.ssh/id_rsa
}

# add ansible pub key
grep 'vagrant@ansible' ~/.ssh/authorized_keys &>/dev/null || [ -f /home/vagrant/ansible_rsa.pub ] && {
  cat /home/vagrant/ansible_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
}

#allow ssh passwordless
grep "vagrant@$PREFIX" ~/.ssh/authorized_keys &>/dev/null || {
  cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
}

#exclude node* from host checking
cat > ~/.ssh/config <<EOF
Host ${PREFIX}*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
#populate /etc/hosts
for x in ${IP_VALUES}; do
  grep $BASE_IP.${x} /etc/hosts &>/dev/null || {
      echo $BASE_IP.${x} $PREFIX${x##?} | sudo tee -a /etc/hosts &>/dev/null
  }
done

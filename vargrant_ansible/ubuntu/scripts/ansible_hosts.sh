#!/bin/bash

grep localhost /etc/ansible/hosts &>/dev/null || {
  echo localhost ansible_connection=local | sudo tee -a /etc/ansible/hosts &>/dev/null
}

for x in ${TOTAL_NODES}; do
  grep $PREFIX${x} /etc/ansible/hosts &>/dev/null || {
      echo $PREFIX${x} ansible_connection=ssh ansible_user=vagrant | sudo tee -a /etc/ansible/hosts &>/dev/null
  }
done

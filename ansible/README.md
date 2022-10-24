# Ansible Playbooks

Edit the host_vars file:

* Rename the IP to be correct in `hosts.ini`.
* Rename the `host_vars/<ip>` file to be correct.
* Edit the `host_vars/<ip>` file to contain the correct variables.

```none
ansible-playbook \
  ./playbooks/setup.yml --ask-become-pass
```

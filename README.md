# Core-Tools Setup

## Install Kubernetes

Install the latest version of kubectl on Linux or MacOS:

```sh
ansible-playbook -i hosts.ini install-kubectl.yaml

```

You may need either --ask-become-pass or ansible_become_pass

## To create cluster infrastructure, run

```sh

ansible-playbook -i hosts.ini webservers.yaml --tags="create"

```

## To destroy cluster infrastructure, run

```sh

ansible-playbook -i hosts.ini webservers.yaml --tags="destroy"

```

## To perform checks on cluster

```sh

ansible-playbook -i hosts.ini webservers.yaml --tags="cluster-checks"

```

### Maintenance

#### Ansible Preview Modules used

Periodically update preview modules until at least stableinterface.
The preview modules may also be downloaded into a library directory.
The following are ansible preview modules used:
    - Role: Gluster
    - Tasks: install_gluster.yml
    - Modules: apt-key & apt_repository

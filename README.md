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
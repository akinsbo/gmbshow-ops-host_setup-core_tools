# Core-Tools Setup

Update the group_vars/all/vars.yml with your route53DNS and subdomains. 
Also, update other variables as necessary.

To run the entire infrastructure play, use:

```sh
ansible-playbook site.yml
```

## Install Kubernetes

Install the latest version of kubectl on Linux or MacOS:

```sh
ansible-playbook cluster.yaml
```

You may need either --ask-become-pass or ansible_become_pass

## To create cluster infrastructure, run

```sh
ansible-playbook cluster.yaml --tags="create"
```

## To destroy cluster infrastructure, run

```sh
ansible-playbook cluster.yaml --tags="destroy"
```

## To perform checks on cluster

```sh
ansible-playbook cluster.yaml --tags="cluster-checks"
```

To create cluster from terraform file, run

```sh
ansible-playbook -i hosts cluster.yaml --tags="terraform-create"
```

To create the hyperconverged glusterfs distributed storage, run

```sh
ansible-playbook -i hosts cluster.yaml --tags="gluster-create
```

### Maintenance

#### Ansible Preview Modules used

Periodically update preview modules until at least stableinterface.
The preview modules may also be downloaded into a library directory.
The following are ansible preview modules used:

    - Modules: apt-key & apt_repository
    - lineinfile Module
    - blockinfile Module

Perform ```grep -r <module>``` to find them.

### Features

#### Autosearch and use Availability Zones

If you specify a 4-node cluster while working in a region with 5 AZ thenthe playbook automatically creates a node in AZs:
    - regiona
    - regionb
    - regionc
    - regiond

#### Autogeneration of AWS credentials for profile

If ~/.aws/credentials, ~/.boto.profile or ~/boto.cfg do not exist, the current aws config
is persisted into the first file in your group_var-specified order of precedence.

### Collaboration

#### Sharing Cluster Config file

To share the cluster configuration, just share your KOPS_STATE_STORE with your colleague.
They can generate it by:

```sh
export KOPS_STATE_STORE=s3://<somes3bucket>
# NAME=<kubernetes.mydomain.com>
${GOPATH}/bin/kops export kubecfg ${NAME}
```

They can now use kubernetes on the cluster e.g.

```sh
kubectl get nodes
```
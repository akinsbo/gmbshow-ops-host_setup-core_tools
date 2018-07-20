# Core-Tools Setup

## Features

This playbook:

* Creates a RBAC enabled kubernetes cluster with bastion on AWS(using Kops)
* Generates a terraform file which it updates for HA bastion and additional ebs volumes for glusterfs
* Generates SSL certificates with Letsencrypt for your domain name and subdomain names
* Creates Glusterfs distributed storage for true StatefulSets development
* Generates OpenSSL self-signed certificates to manage Helm
* Provisions Helm secured with a service account and tls
* Provisions Istio service mesh on the gluster storage
* Provisions HashiVault (with POSTGRESQL) to manage secrets
* Provisions Jenkins on the cluster on the gluster storage on ssl encrypted endpoint
* Provisions Kubernetes Dashboard and other addons (Including Heapster, infludb-grafana,  prometheus-operator)

### Autosearch and use Availability Zones

If you specify a 4-node cluster while working in a region with 5 AZ thenthe playbook automatically creates a node in AZs:

    - regiona
    - regionb
    - regionc
    - regiond

## Usage

Update the group_vars/all/vars.yml with your route53DNS and subdomains.
Also, update **group_vars/all/vault.yml** and encrypt with ansible-vault.
Update other variables as necessary.

To run the entire infrastructure play, use:

```sh
ansible-playbook site.yml
```

### Create Cluster

You may need either --ask-become-pass or ansible_become_pass

To create cluster infrastructure (with HA bastion), run

```sh
ansible-playbook cluster.yaml --tags="create"
```

To destroy cluster infrastructure, run

```sh
ansible-playbook cluster.yaml --tags="destroy"
```

To perform checks on cluster

```sh
ansible-playbook cluster.yaml --tags="cluster-checks"
```

To create cluster from terraform file, run

```sh
ansible-playbook cluster.yaml --tags="terraform-create"
```

### Create Distributed Storage

To create the hyperconverged glusterfs distributed storage, run

```sh
ansible-playbook storage.yaml
```

### Create Service Mesh

```sh
ansible-playbook network.yaml
```

### Create Vault

```sh
ansible-playbook security.yaml
```

### Jenkins

```sh
ansible-playbook ci_cd.yaml
```

### Bootstrap a secure Linux or Debian OS

Cleanly bootstrap a secure Linux or Deian OS

```sh
ansible-playbook bootstrap_os.yaml
```

It does the following:

* Root signing
* ------------create-user----------------------

* Create new user

** If Debian8, install sudo

* Root privileges: Add user to sudo group

* ------------setup ssh-key-------------------

* Add Public Key Authentication

** Generate key pair
** Copy the public key

* Disable Password Authentication

* Test Log in
* ------------firewall-------------------
* Setup a Basic firewall

### Install Ansible, Kops and dependencies

To install virtual environments for Python2 an Python3, ansible, redis cache(for ansible), Kubernetes, kops and their dependencies in both *Debian 8* and *Ubuntu 16* or *MacOS*:

```sh
ansible-playbook controllers.yaml
```

### Autogeneration of AWS credentials for profile

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

### Maintenance

#### Ansible Preview Modules used

Periodically update preview modules until at least stableinterface.
The preview modules may also be downloaded into a library directory.
The following are ansible preview modules used:

    - Modules: apt-key & apt_repository
    - lineinfile Module
    - blockinfile Module

Perform ```grep -r <module>``` to find them.
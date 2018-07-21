# Core-Tools Setup

## Features

This playbook:

* Generates a RBAC enabled kubernetes cluster config with bastion on AWS(using Kops)
* Generates a Terraform file which Ansible updates for HA bastion, adds additional ebs volumes for glusterfs, generates a tfstate file used to spin the kubernetes cluster.
* Generates SSL certificates with Letsencrypt for your domain name and subdomain names
* Creates Glusterfs distributed storage for true StatefulSets development for your database of choice.
* Generates OpenSSL self-signed certificates to manage Helm
* Provisions Helm secured with a service account and tls (so each team has their own secure namespaced tiller, minimizing blast radius of tiller repo vulnerability)
* Provisions Istio service mesh on the gluster storage
* Provisions and enables Kubernetes Auth in HashiVault (with POSTGRESQL) to manage service accounts
* Provides automation of HashiVault lease revoke and renew, write policy, read, write and get vault tokens
* Provisions Jenkins on the cluster on the gluster storage on ssl encrypted endpoint
* Provisions Kubernetes Dashboard and other addons (Including Heapster, infludb-grafana,  prometheus-operator)
* Also:
  * Bootstraps a secure Linux or Debian OS
  * Turns a localhost into a controller by install Ansible, Kops and their dependencies
  * Autoselect AZ to use when very few nodes are defined for quick test scenarios

### Autosearch and use Availability Zones

If you specify a 4-node cluster while working in a region with 5 AZ then the playbook automatically creates a node in AZs:

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

Remember to adjust the gluster ebs volume (named cluster_accessories.spare_device1) in group_vars/all/vars.yml to your desired size.

### Create Service Mesh

To create istio service mesh, run:

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

* Root sign in
* Create new user
  * If Debian8, install sudo
  * Ensure root privileges: Add new user to sudo group
* Setup ssh-key
  * Add Public Key Authentication
  * Generate key pair
  * Copy the public key to authorized keys
  * Disable Password Authentication in ssh config
* Test Log in
* Firewall
  * Setup openssh rules
  * Setup a Basic ufw firewall

### Create a controller (Install Ansible, Kops and dependencies)

To install virtual environments for Python2 and Python3, ansible, redis cache(for ansible), Kubernetes, kops and their dependencies in both *Debian 8* and *Ubuntu 16* or *MacOS*:

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

## Maintenance

### Ansible Preview Modules used

Periodically update preview modules until at least stableinterface.
The preview modules may also be downloaded into a library directory.
The following are ansible preview modules used:

    - Modules: apt-key & apt_repository
    - lineinfile Module
    - blockinfile Module

Perform ```grep -r <module>``` to find them.sign

## Security Group Rules of Cluster

| master-in                                         |
|---------------------------------------------------|
| all-master-to-master(00)                          |
| bastion-to-master-ssh(22,22)                      |
| https-elb-to-master(443,443)                      |
| node-to-master-protocol-ipip(0, 65535)@protocol:4 |
| node-to-master-tcp-1-2379(1, 2379)                |
| node-to-master-tcp-2382-4001                      |
| node-to-master-tcp-4003-65535                     |
| node-to-master-udp-1-65535                        |

| master-out        |
|-------------------|
| master-egress(00) |

| node-in                    |
|----------------------------|
| all-master-to-node(00)     |
| all-node-to-node(00)       |
| bastion-to-node-ssh(22,22) |

| node-out        |
|-----------------|
| node-egress(00) |

| cluster-in                        |
|-----------------------------------|
| https-api-elb-0-0-0-0--0(443,443) |

| cluster-out                        |
|------------------------------------|
| api-elb-egress(00): Cluster to elb |

| bastion-in                                                                             |
|----------------------------------------------------------------------------------------|
| ssh-external-to-bastion-elb-0-0-0-0--0(22,22)(i.e from my engine to bastion's own elb) |
| ssh-bastion-elb-to-bastion(22,22)                                                      |

| bastion-out            |
|------------------------|
| bastion-egress(00)     |
| bastion-elb-egress(00) |
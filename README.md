Monitoring stack playbook
---

### Description

This playbook will deploy the netdata/InfluxDB/grafana stack on an admin machine + N nodes. It comes preconfigured
with all the necessary retention policies, queries, credentials, and an out of the box dashboard.


### Prerequisites:

- Ubuntu Xenial / CentOS 7
- Ansible 2.4 (see below for install on Ubuntu)

### Ansible 2.4 install

> **Ubuntu Xenial**
```sh
sudo bash
apt update
apt install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible
```

---

> **CentOS 7**
```
sudo yum install -y ansible
```

### Setup

Clone this repo and install role dependencies:

```
ansible-galaxy install -r requirements.yml
```

First setup your inventory according to [this example](inventory/testing.ini).

Now replace ADMIN_IP by the IP of your admin node in [the playbook](site.yml)

### Run

```sh
ansible-playbook site.yml
```

head to `http://[ADMIN_IP]:3000` and login with credentials (default `admin:admin`), then head to the dashboard named `OPENIO`.

> Some metrics still depend on diamond, and will not be displayed. Look in the first sections to see common graphs.

### Contribute

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome. The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork. Github can then easily create a PR based on that branch.

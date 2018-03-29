Monitoring stack playbook
---

[![Build Status](https://travis-ci.org/vdombrovski/ansible-openio-monitoring.svg?branch=master)](https://travis-ci.org/vdombrovski/ansible-openio-monitoring)

### Description

This playbook will deploy the Netdata/Prometheus/Grafana stack on an admin machine + N nodes. It comes preconfigured with an out of the box dashboard.


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
```sh
sudo yum install -y ansible
```

---

> **Other distribution**
```sh
virtualenv ansible24
cd ansible24/
. ./bin/activate
pip install --upgrade pip
pip install ansible>=2.4
```

---

### Setup

Download the latest release of this playbook and install role dependencies:

```sh
export OPENIO_MONITORING_RELEASE="v2.0.0"
mkdir -p ~/ansible-openio-monitoring && cd ~/ansible-openio-monitoring
curl -sL "https://github.com/vdombrovski/ansible-openio-monitoring/archive/$OPENIO_MONITORING_RELEASE.tar.gz" | tar xz --strip-components=1
ansible-galaxy install -r requirements.yml --force
```

You will need to **change your inventory file** according to [this example](inventory/testing.ini).

```sh
cp inventory/testing.ini inventory/current.ini
# vim inventory/current.ini
```

---

### Run

```sh
ansible-playbook -i inventory/current.ini main.yml
```

head to `http://[ADMIN_IP]:3000` and login with credentials (default `admin:admin`), then head to the dashboard named `OPENIO`.


### Contribute

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome. The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork. Github can then easily create a PR based on that branch.

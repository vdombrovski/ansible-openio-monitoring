Monitoring stack playbook (netdata only)
===

Description:
---

This procedure will:
- Install netdata + collectors on nodes you wish to monitor
- Provide a job to add to prometheus in order to scrape these

Prerequisites:
---

- Ansible ~2.4 installed on an admin machine
- Python2 installed on all nodes
- Inventory file matching the following:
    - it is located at `$INVENTORY_FILE_PATH`
    - a group with all nodes you want to monitor (called `$MONITORED_HOST_GROUP` in this example)
    - a group with only the admin machine (called `$ADMIN_HOST_GROUP` in this example)
> You need to be able to execute commands via ansible on each of the nodes, use this to check connectivity:
>
> `ansible openio -i $INVENTORY_FILE_PATH -m shell -a "echo 'test'"`
- An open port (preferably 19999) on all monitored nodes (in regards to the admin machine), called `$NETDATA_PORT`
- The name of the network interface on all the **monitored** nodes that can be communicate with the machine that runs Prometheus. (called `$MONITORED_HOST_IFACE`)
- A destination for the sample file containing the netdata job (`$SCRAPE_FILE_DESTINATION`)

<p style="page-break-after: always;">&nbsp;</p>

Setup:
---

1. Download and install requirements
```sh
mkdir ansible-openio-monitoring && cd ansible-openio-monitoring
curl -sL "https://github.com/vdombrovski/ansible-openio-monitoring/archive/v2.1.2.tar.gz" | tar xz --strip-components=1
ansible-galaxy install -r requirements.yml
```

2. Generate an rc file, **REPLACE** the corresponding pieces of information with the ones obtained from the prerequisites:
```sh
cat << EOF > .varsrc
export MONITORED_HOST_GROUP=openio
export ADMIN_HOST_GROUP=admin
export INVENTORY_FILE_PATH=/tmp/inventory.ini
export SCRAPE_FILE_DESTINATION=/tmp/prometheus_scrape_job.yml
export NETDATA_PORT=19999
export MONITORED_HOST_IFACE=eth0
EOF
```

3. Generate the playbook using the rc file:
```sh
source .varsrc
envsubst < "playbooks/main.yml.tpl" > "playbooks/main.yml"
```

4. Play the playbook
```sh
ansible-playbook -i $INVENTORY_FILE_PATH main.yml
```

5. Get the generated job configuration by looking into the generated scrape file:
```sh
# Example output
$ cat $SCRAPE_FILE_DESTINATION
scrape_configs:
  - job_name: netdata_openio
    scrape_interval: 10s
    metrics_path: '/api/v1/allmetrics'
    params:
      format: [prometheus_all_hosts]
    honor_labels: True
    static_configs:
    - targets: ["10.0.2.161:19999","10.0.2.162:19999","10.0.2.163:19999"]
```

6. Add the job in `/etc/prometheus/prometheus.yml` in the `scrape_configs` section, then reload prometheus.

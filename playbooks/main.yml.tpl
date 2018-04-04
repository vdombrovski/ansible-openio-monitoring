---
- name: Install netdata on monitored nodes
  hosts: $MONITORED_HOST_GROUP
  become: true
  gather_facts: true
  roles:
    - role: ansible-role-openio-netdata
      netdata_openio_namespaces: "OPENIO"
      netdata_default_port: $NETDATA_PORT
      netdata_openio_plugins:
        - name: openio
          enabled: true
          every: 10
          opts: ""
        - name: zookeeper
          enabled: true
          every: 10
          opts: ""
      netdata_backend_enabled: true
      netdata_openio_plugins_version: "0.2.13"

- name: "Generate scrape config for prometheus"
  hosts: all
  become: true
  gather_facts: true
  vars:
    scrape_conf_file_dest: $SCRAPE_FILE_DESTINATION
    scrape_monitored_group: $MONITORED_HOST_GROUP
    scrape_admin_group: $ADMIN_HOST_GROUP
    scrape_netdata_port: $NETDATA_PORT
    scrape_net_iface: $MONITORED_HOST_IFACE
  tasks:
  - name: Generate scrape config
    template:
      src: scrape.yml.j2
      dest: "{{ scrape_conf_file_dest }}"
      owner: "root"
      group: "root"
    when: "scrape_admin_group in group_names"
...

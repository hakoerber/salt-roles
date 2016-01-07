#!stateconf

include:
  - states.ssh.server
  - states.ssh.server.conf
  - states.ssh.server.keys
  - states.ssh.server.logging

  - roles.logging.client
  - roles.logging.local

{% if grains['os_family'] != 'FreeBSD' %}
  - states.ssh.server.iptables
  - roles.firewall
{% endif %}

extend:
  states.ssh.server.conf::params:
    stateconf.set:
      - listen_address: {{ salt['pillar.get']('applications:ssh:server:listen_address', 'all') }}

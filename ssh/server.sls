#!stateconf

include:
  - states.ssh.server
  - states.ssh.server.conf
  - states.ssh.server.keys
  - states.ssh.server.logging
{% if grains['os_family'] != 'FreeBSD' %}
  - states.ssh.server.iptables
{% endif %}

extend:
  states.ssh.server.conf::params:
    stateconf.set:
      - listen_address: {{ pillar.applications.ssh.server.listen_address }}

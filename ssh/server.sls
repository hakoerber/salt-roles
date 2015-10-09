#!stateconf

include:
  - states.ssh.server
  - states.ssh.server.conf
  - states.ssh.server.keys
{% if 'roles.logging.client' in salt['state.show_top']().get(env) %}
  - states.ssh.server.logging
{% endif %}
{% if grains['os_family'] != 'FreeBSD' %}
{% if 'roles.firewall' in salt['state.show_top']().get(env) %}
  - states.ssh.server.iptables
{% endif %}
{% endif %}

extend:
  states.ssh.server.conf::params:
    stateconf.set:
      - listen_address: {{ salt['pillar.get']('applications:ssh:server:listen_address', 'all') }}

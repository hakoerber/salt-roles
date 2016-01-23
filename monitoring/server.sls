#!stateconf

{% set domain = pillar.applications.monitoring.server.domain %}
{% set monitoring = pillar.domain.get(domain).applications.monitoring %}

{% set clients = [] %}
{% for client in monitoring.clients %}
{% do clients.append({
  'name': client.name + '.' + domain,
  'ip': client.ip,
  'groups': [client.type],
}) %}
{% endfor %}

{% set groups = [] %}

{% set influxdb = pillar.applications.monitoring.server.database %}

include:
  - states.nagios
  - states.nagios.selinux
  - states.nagios.conf

  - states.nagios.check_mk.server
  - states.nagios.check_mk.server.livestatus
  - states.nagios.check_mk.server.conf
  - states.nagios.check_mk.server.iptables

  - states.nagios.graphios
  - states.nagios.graphios.conf

extend:
  states.nagios.check_mk.server.conf::params:
    stateconf.set:
      - hosts: {{ clients }}
      - groups: {{ groups }}
  states.nagios.graphios.conf::params:
    stateconf.set:
      - influxdb: {{ influxdb }}

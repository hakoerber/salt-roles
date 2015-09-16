#!stateconf

{% if grains['os_family'] != 'FreeBSD' %}
include:
  - states.iptables
  - states.iptables.conf
  - states.iptables.zones

{# extract zones from all networks #}
{% set zones = {
    'public': {
      'sources': ['0.0.0.0/0'],
    },
    'local': {
      'sources': [],
    },
  }
%}

{% set networks = pillar.get('interfaces', {}).keys() %}
{% for network in networks %}
{% set netdata = pillar.get('network', {}).get(network) %}

{# add an implicit "local" zone containing all networks with the "local"
flag set #}
{% if netdata.get('local', False) %}
{% do zones.local.sources.append(netdata.ip + "/" + netdata.prefix) %}
{% endif %}

{# add explicit zones #}
{% do zones.update(netdata.get('zones', {})) %}
{% endfor %}

extend:
  states.iptables.zones::params:
    stateconf.set:
      - zones: {{ zones }}
{% endif %}

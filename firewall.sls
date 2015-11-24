#!stateconf
{% from 'roles/helpers/net.jinja' import localnets with context %}

{% if grains['os_family'] != 'FreeBSD' %}
include:
  - states.iptables
  - states.iptables.conf
  - states.iptables.zones
{% if 'roles.logging.client' in salt['state.show_top']().get(env) %}
  - states.iptables.logging
{% endif %}

{# extract zones from all networks #}
{% set zones = {
    'public': {
      'sources': ['0.0.0.0/0'],
    },
    'local': {
      'sources': localnets,
    },
  }
%}

{% set networks = pillar.get('interfaces', {}).keys() %}
{% for network in networks %}
{% set netdata = pillar.get('network', {}).get(network, {}) %}

{# add explicit zones #}
{% do zones.update(netdata.get('zones', {})) %}
{% endfor %}

extend:
  states.iptables.zones::params:
    stateconf.set:
      - zones: {{ zones }}
{% endif %}

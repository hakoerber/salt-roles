#!stateconf

{% set domain = pillar['applications']['metrics']['database']['domain'] %}
{% set clusterinfo = pillar['domain'][domain]['applications']['metrics']['database']['cluster'] %}

{% set cluster = {
  'nodes': clusterinfo['nodes']|map(attribute="name")|list|sort
} %}

include:
  - states.influxdb
  - states.influxdb.conf
  - states.influxdb.iptables

extend:
  states.influxdb.conf::params:
    stateconf.set:
      - domain: {{ domain }}
      - cluster: {{ cluster }}
      - data: {{ pillar.get('applications', {}).get('metrics', {}).get('database', {}).get('data', True) }}

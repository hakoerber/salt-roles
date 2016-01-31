#!stateconf

{% set domain = pillar['applications']['logging']['database']['domain'] %}
{% set clusterinfo = pillar['domain'][domain]['applications']['logging']['database']['cluster'] %}

{% set cluster = {
  'name': clusterinfo['name'],
  'nodes': clusterinfo['nodes']|map(attribute="name")|list|sort
} %}

include:
  - states.elasticsearch
  - states.elasticsearch.conf
  - states.elasticsearch.iptables

extend:
  states.elasticsearch.conf::params:
    stateconf.set:
      - cluster: {{ cluster }}
      - data: {{ pillar.get('applications', {}).get('logging', {}).get('database', {}).get('data', True) }}

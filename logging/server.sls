#!stateconf

include:
  - states.logstash
  - states.logstash.iptables

{% set listeners = pillar.get('applications', {}).get('logging', {}).get('listeners', []) %}

extend:
  states.logstash.iptables::params:
    stateconf.set:
      - listeners: {{ listeners }}

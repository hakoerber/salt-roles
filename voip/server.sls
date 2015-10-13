#!stateconf

include:
  - states.murmur
  - states.murmur.conf
  - states.murmur.iptables

{% set password = pillar.get('applications', {}).get('voip', {})['password'] %}

extend:
  states.murmur.conf::params:
    stateconf.set:
      - password: {{ password }}

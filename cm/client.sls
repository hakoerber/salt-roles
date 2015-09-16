#!stateconf

include:
  - states.salt.minion
  - states.salt.minion.conf

{% set master = 'salt' %}

extend:
  states.salt.minion.conf::params:
    stateconf.set:
      - master: {{ master }}

#!stateconf

include:
  - states.salt.minion
  - states.salt.minion.conf
  - states.salt.minion.logging

{% set master = 'salt' %}

extend:
  states.salt.minion.conf::params:
    stateconf.set:
      - master: {{ master }}

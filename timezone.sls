#!stateconf

include:
  - states.timezone

extend:
  states.timezone::params:
    stateconf.set:
      - timezone: {{ pillar.timezone }}

#!stateconf

include:
  - states.postfix
  - states.postfix.conf

extend:
  states.postfix.conf::params:
    stateconf.set:
      - listen_remote: False

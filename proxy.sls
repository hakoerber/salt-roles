#!stateconf

include:
  - states.nginx
  - states.nginx.iptables
  - states.nginx.logging

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - http: True
      - https: True

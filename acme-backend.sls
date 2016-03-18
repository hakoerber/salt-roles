#!stateconf

include:
  - states.nginx
  - states.nginx.iptables
  - states.nginx.logging
  - states.nginx.conf
  - states.nginx.logrotate

  - states.acme
  - states.acme.user

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - ipv6: False
      - public: False
      - http: True
      - https: False
  states.nginx.conf::params:
    stateconf.set:
      - ipv6: False
      - acme: True

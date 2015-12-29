#!stateconf

include:
  - states.nginx
  - states.nginx.conf
  - states.nginx.logging
  - states.nginx.iptables

{% set content = {
  'protocol': 'http',
  'path': '/srv/www/packages',
  'autoindex': True,
} %}

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - public: True
      - http: True
      - https: False
  states.nginx.conf::params:
    stateconf.set:
      - static_content: {{ content }}


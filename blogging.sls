#!stateconf

include:
  - states.nginx
  - states.nginx.iptables
  - states.nginx.logging
  - states.nginx.conf

{% set content = {
  'protocol': 'http',
  'path': '/var/lib/hexo/blog/public',
} %}

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - http: True
      - https: False
  states.nginx.conf::params:
    stateconf.set:
      - group: hexo
      - static_content: {{ content }}


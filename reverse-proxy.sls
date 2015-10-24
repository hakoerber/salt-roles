#!stateconf

include:
  - states.nginx
  - states.nginx.iptables
  - states.nginx.logging
  - states.nginx.conf
  - states.nginx.logrotate

{% set reverse_proxy = pillar.get('applications', {}).get('reverse_proxy', {}) %}
{% set upstream = reverse_proxy.get('upstream', {}) %}
{% set protocols = reverse_proxy.get('protocols', {}) %}
{% set public = reverse_proxy.get('public', {}) %}

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - public: {{ public }}
      - http: {{ 'http' in protocols }}
      - https: {{ 'https' in protocols }}
  states.nginx.conf::params:
    stateconf.set:
      - reverse_proxy:
          protocol: {{ protocols }}
          upstream: {{ upstream }}

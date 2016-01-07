#!stateconf

include:
  - states.nginx
  - states.nginx.iptables
  - states.nginx.logging
  - states.nginx.conf
  - states.nginx.logrotate
  - states.nginx.pki

{% set reverse_proxy = pillar.get('applications', {}).get('reverse_proxy', {}) %}
{% set upstream = reverse_proxy.get('upstream', {}) %}
{% set protocols = reverse_proxy.get('protocols', {}) %}
{% set public = reverse_proxy.get('public', {}) %}
{% set ipv6 = reverse_proxy.get('ipv6', False) %}
{% set simple_ssl = reverse_proxy.get('simple_ssl', False) %}
{% set master_dhparams = reverse_proxy.get('master_dhparams', True) %}

extend:
  states.nginx.iptables::params:
    stateconf.set:
      - ipv6: {{ ipv6 }}
      - public: {{ public }}
      - http: True
      - https: {{ 'https' in protocols }}
  states.nginx.conf::params:
    stateconf.set:
      - ipv6: {{ ipv6 }}
      - reverse_proxy:
          protocol: {{ protocols }}
          upstream: {{ upstream }}
      - ssl:
          simple: {{ simple_ssl }}
  states.nginx.pki::params:
    stateconf.set:
      - master_dhparams: {{ master_dhparams }}
      - fullchain: False

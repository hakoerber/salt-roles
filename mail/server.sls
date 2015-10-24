#!stateconf

include:
  - states.postfix
  - states.postfix.conf
  - states.postfix.iptables

{% set mail = pillar.get('applications', {}).get('mail', {}) %}

{% set domain = mail['domain'] %}
{% set subdomain = mail['subdomain'] %}
{% set relay = mail.get('relay', {}) %}{% set aliases = mail.get('aliases', []) %}
{% set domain_authorative = mail.get('domain_authorative', False) %}

extend:
  states.postfix.conf::params:
    stateconf.set:
      - listen_remote: True
      - hostname: {{ subdomain }}.{{ domain }}
      - domain: {{ domain }}
      - relay: {{ relay }}
      - aliases: {{ aliases }}
      - domain_authorative: {{ domain_authorative }}

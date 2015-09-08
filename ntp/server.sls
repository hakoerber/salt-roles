#!stateconf

include:
  - states.ntp
  - states.ntp.conf
  - states.ntp.iptables

{% set domain = pillar.applications.ntp.domain %}
{% set ntpinfo = pillar.domain.get(domain).applications.get('ntp', {}) %}

extend:
  states.ntp.conf::params:
    stateconf.set:
      - network: {{ pillar.network.get(domain) }}
      - external_servers: {{ ntpinfo.get('external_servers') }}
      - is_server: {{ pillar.applications.ntp.server|default(False) }}
      - servers: {{ ntpinfo.servers }}
      - authorative: {{ pillar.applications.ntp.authorative|default(True) }}
      - authorative_servers: {{ ntpinfo.authorative_servers }}
  states.ntp.iptables::params:
    stateconf.set:
      - is_server: {{ ntpinfo.server|default(False) }}

#!stateconf

include:
  - states.rsyslog
  - states.rsyslog.conf
  - states.rsyslog.conf.client

{% set logservers = [] %}

{% set domains = pillar.interfaces.keys() %}
{% for domain in domains %}
{% set domdata = pillar.domain.get(domain, {}) %}
{% set domlogservers = domdata.get('applications', {}).get('logging', {}).get('servers', []) %}
{% for domlogserver in domlogservers %}
{% do domlogserver.update({"domain":domain}) %}
{% do logservers.append(domlogserver) %}
{% endfor %}
{% endfor %}

{% set local = pillar.applications.get('logging', {}).get('local', True) %}

extend:
  states.rsyslog.conf.client::params:
    stateconf.set:
      - local: {{ local }}
      - servers: {{ logservers }}

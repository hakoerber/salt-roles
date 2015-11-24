#!stateconf

include:
  - states.rsyslog
  - states.rsyslog.conf
  - states.rsyslog.conf.client
  - states.rsyslog.logrotate

{% set logservers = [] %}

{% set domains = pillar.get('interfaces', {}).keys() %}
{% for domain in domains %}
{% set domdata = pillar.domain.get(domain, {}) %}
{% set domlogservers = domdata.get('applications', {}).get('logging', {}).get('servers', []) %}
{% for domlogserver in domlogservers %}
{% do domlogserver.update({"domain":domain}) %}
{% do logservers.append(domlogserver) %}
{% endfor %}
{% endfor %}

extend:
  states.rsyslog.conf.client::params:
    stateconf.set:
      - servers: {{ logservers }}

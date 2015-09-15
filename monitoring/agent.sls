#!stateconf

{% set conf_firewall = True %}
{% if grains['os_family'] == 'FreeBSD' %}
{% set conf_firewall = False %}
{% endif %}

include:
  - states.nagios.check_mk.agent
  - states.nagios.check_mk.agent.conf
  {% if conf_firewall %}
  - states.nagios.check_mk.agent.iptables
  {% endif %}

{% set monitoring_servers = [] %}

{% set domains = pillar.interfaces.keys() %}
{% for domain in domains %}
{% set domdata = pillar.domain.get(domain, {}) %}
{% set dom_monitoring_servers = domdata.get('applications', {}).get('monitoring', {}).get('servers', []) %}
{% do monitoring_servers.extend(dom_monitoring_servers) %}
{% endfor %}

extend:
  states.nagios.check_mk.agent.conf::params:
    stateconf.set:
      - servers: {{ monitoring_servers }}
  {% if conf_firewall %}
  states.nagios.check_mk.agent.iptables::params:
    stateconf.set:
      - servers: {{ monitoring_servers }}
  {% endif %}

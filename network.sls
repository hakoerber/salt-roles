#!stateconf

include:
  - states.network

{# get the hostname #}
{% set primary_domain = none %}
{% if pillar.network.keys()|length == 1 %}
  {% set primary_domain = pillar.network.keys()[0] %}
{% else %}
  {% for domain, interface in pillar.get('interfaces', {}).items() %}
    {% if interface.get('primary', False) %}
      {% set primary_domain = domain %}
      {% break %}
    {% endif %}
  {% endfor %}
{% endif %}
{% set hostname = pillar.hostname + '.' + primary_domain %}


{# get interface info #}
{% set interfaces = [] %}

{% for domain, interface in pillar.get('interfaces', {}).items() %}
  {% set new_interface = {} %}
  {% set name = interface.get('identifier') %}
  {% if name is none %}
    {% continue %}
  {% endif %}

  {% do new_interface.update({
    'name': name,
    'mac': interface.mac,
    'type': interface.type|default('eth'),
    'mode': interface.mode}) %}

  {% if interface.mode == 'static' %}
    {% set netinfo = pillar.network.get(domain, {}) %}
    {% set dominfo = pillar.domain.get(domain, {}) %}

    {% do new_interface.update({
      'address': interface.ip,
      'netmask': netinfo.netmask,
      'gateway': netinfo.default_gateway,
      'nameservers': dominfo.applications.dns.zoneinfo.nameservers|map(attribute='ip')|list}) %}
  {% endif %}

  {% do interfaces.append(new_interface) %}
{% endfor %}

extend:
  states.network::params:
    stateconf.set:
      - hostname: {{ hostname }}
      - interfaces: {{ interfaces }}

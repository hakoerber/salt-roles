#!stateconf

include:
  - states.sudo
  - states.sudo.conf
  - states.sudo.logging
  - states.sudo.logrotate

{% set group = 'sudo' %}
{% set group_nopw = 'sudonopw' %}

extend:
  states.sudo.conf::params:
    stateconf.set:
      - group: {{ group }}
      - group_nopw: {{ group_nopw }}
      - policies: {{ pillar.get('applications', {}).get('sudo', {}).get('policies', []) }}

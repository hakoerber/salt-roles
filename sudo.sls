#!stateconf

include:
  - states.sudo
  - states.sudo.conf

{% set group = 'sudo' %}
{% set group_nopw = 'sudonopw' %}

extend:
  states.sudo.conf::params:
    stateconf.set:
      - group: {{ group }}
      - group_nopw: {{ group_nopw }}

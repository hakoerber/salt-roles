#!stateconf

include:
  - states.package.autoupdate
  - states.package.autoupdate.conf

{% set mode = pillar.applications.get('autoupdate', {}).get('mode', None) %}

{% if mode != None %}
extend:
  states.package.autoupdate.conf::params:
    stateconf.set:
      - mode: {{ mode }}
{% endif %}

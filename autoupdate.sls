#!stateconf

include:
  - states.package.autoupdate
  - states.package.autoupdate.conf

{% set mode = pillar.get('applications', {}).get('autoupdate', {}).get('mode', 'all') %}

extend:
  states.package.autoupdate.conf::params:
    stateconf.set:
      - mode: {{ mode }}

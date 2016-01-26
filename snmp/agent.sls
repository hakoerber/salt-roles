#!stateconf

include:
  - states.snmpd
  - states.snmpd.conf
  - states.snmpd.iptables

  - roles.logging.client
  - roles.firewall
  - roles.logging.local

{% set sysinfo = {
  'location': pillar['machine'].get('location'),
  'contact': pillar['machine'].get('contact'),
} %}

extend:
    states.snmpd.conf::params:
      stateconf.set:
        - sysinfo: {{ sysinfo }}

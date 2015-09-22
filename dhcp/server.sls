#!stateconf

include:
  - states.dhcpd
  - states.dhcpd.conf
  - states.dhcpd.iptables
  - states.dhcpd.logging

{% set network = pillar.network.get(pillar.applications.dhcp.network) %}
{% set dhcpinfo = network.applications.dhcp %}

extend:
  states.dhcpd.conf::params:
    stateconf.set:
      - network: {{ network }}
      - role: {{ pillar.applications.dhcp.role }}
      - primary: {{ dhcpinfo.failover.primary }}
      - secondary: {{ dhcpinfo.failover.secondary }}
      - range: {{ dhcpinfo.range }}
      - reservations: {{ dhcpinfo.reservations }}
      - nameservers: {{ pillar.domain.get(pillar.applications.dhcp.network).applications.dns.zoneinfo.nameservers }}
      - ntpservers: {{ pillar.domain.get(pillar.applications.dhcp.network).applications.ntp.servers }}
      - domain: {{ network.domain }}
      - dhcpoptions: {{ dhcpinfo.options }}
  states.dhcpd.iptables::params:
    stateconf.set:
      - role: {{ pillar.applications.dhcp.role }}
      - primary: {{ dhcpinfo.failover.primary }}
      - secondary: {{ dhcpinfo.failover.secondary }}

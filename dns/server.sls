#!stateconf

include:
  - states.bind
  - states.bind.conf
  - states.bind.iptables

{% set domain = pillar.applications.dns.domain %}
{% set domain_reverse = pillar.network.get(domain).domain_reverse %}
{% set dnsinfo = pillar.domain.get(domain).applications.dns %}

extend:
  states.bind.conf::params:
    stateconf.set:
      - nameservers: {{ dnsinfo.zoneinfo.nameservers }}
      - role: {{ pillar.applications.dns.role }}
      - mailservers: {{ dnsinfo.zoneinfo.mailservers }}
      - domain: {{ domain }}
      - domain_reverse: {{ domain_reverse }}
      - zoneinfo: {{ dnsinfo.zoneinfo }}
      - forwarders: {{ dnsinfo.forwarders }}
      - records: {{ dnsinfo.zoneinfo.records }}
      - dnssec: {{ dnsinfo.dnssec|default(True) }}
      - network: {{ pillar.network.get(domain) }}
      - listen: {{ pillar.interfaces.get(domain).ip }}
      - master: {{ dnsinfo.master }}
      - slaves: {{ dnsinfo.slaves }}

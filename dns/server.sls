#!stateconf
{% from 'roles/helpers/net.jinja' import localnets with context %}

include:
  - states.bind
  - states.bind.conf
  - states.bind.zones
  - states.bind.iptables
  - states.bind.logging
  - states.bind.logrotate

  - roles.firewall
  - roles.logging.client
  - roles.logging.local

{% set domain = pillar.applications.dns.domain %}
{% set domain_reverse = pillar.network.get(domain).domain_reverse %}
{% set dnsinfo = pillar.domain.get(domain).applications.dns %}

{% set params = [
    {'nameservers': dnsinfo.zoneinfo.nameservers},
    {'role': pillar.applications.dns.role},
    {'mailservers': dnsinfo.zoneinfo.mailservers},
    {'domain': domain},
    {'domain_reverse': domain_reverse},
    {'zoneinfo': dnsinfo.zoneinfo},
    {'forwarders': dnsinfo.forwarders},
    {'records': dnsinfo.zoneinfo.records},
    {'dnssec': dnsinfo.dnssec|default(True)},
    {'networks': localnets},
    {'listen': pillar.interfaces.get(domain).ip},
    {'master': dnsinfo.master},
    {'slaves': dnsinfo.slaves},] %}

extend:
  states.bind.conf::params:
    stateconf.set: {{ params }}
  states.bind.zones::params:
    stateconf.set: {{ params }}

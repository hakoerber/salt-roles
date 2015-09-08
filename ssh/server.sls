#!stateconf

include:
  - states.ssh.server
  - states.ssh.server.conf
  - states.ssh.server.iptables
  - states.ssh.server.keys

extend:
  states.ssh.server.conf::params:
    stateconf.set:
      - listen_address: {{ pillar.applications.ssh.server.listen_address }}

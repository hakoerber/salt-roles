#!stateconf

include:
  - states.users
  - states.users.ssh
  - states.users.dotfiles

{% set users = pillar.get('users', {}) %}

extend:
  states.users::params:
    stateconf.set:
      - users: {{ users }}
  states.users.ssh::params:
    stateconf.set:
      - users: {{ users }}
  states.users.dotfiles::params:
    stateconf.set:
      - users: {{ users }}


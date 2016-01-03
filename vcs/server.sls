#!stateconf

include:
  - states.git
  - states.git.user

  - states.nginx
  - states.nginx.conf
  - states.nginx.logging
  - states.nginx.iptables

  - states.uwsgi
  - states.uwsgi.conf

  - roles.logging.client
  - roles.firewall
  - roles.logging.local

{% set protocols = ['http'] %}

{% set cgi = {
  'socket': '/run/uwsgi/uwsgi.sock',
  'params': {
    'GIT_PROJECT_ROOT': '/var/lib/git',
    'PATH_INFO': '$uri',
  }
} %}

extend:
    states.nginx.iptables::params:
      stateconf.set:
        - http: {{ 'http' in protocols }}
        - https: {{ 'https' in protocols }}
  states.nginx.conf::params:
    stateconf.set:
      - group: git
      - cgi: {{ cgi }}
      - ipv6: False
      - protocols: {{ protocols }}
  states.uwsgi.conf::params:
    stateconf.set:
      - user: nginx
      - group: git
      - backend: /usr/libexec/git-core/git-http-backend

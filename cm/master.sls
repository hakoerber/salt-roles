#!py_c|stateconf -p

app = 'salt.master'

def run():
    config = prepare()

    appcfg = appconf(app)

    include('states.salt.master', config)
    include('states.salt.master.conf', config,
        repos=appcfg['repos'],
        pillar_roots=appcfg['pillar_roots'])
    include('states.salt.master.iptables', config)
    include('states.salt.master.cherrypy', config,
        users=appcfg['external_users'])
    include('states.salt.master.reactor', config,
        events=appcfg['reactor']['events'])
    include('states.salt.master.inventory', config)
    include('states.salt.master.nodegroups', config,
        nodegroups=appcfg['nodegroups'])
    include('states.salt.master.logging', config)
    return config

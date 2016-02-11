#!py_c|stateconf -p

app = 'monitoring.dashboard'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)
    cluster = domcfg['applications']['logging']['database']['cluster']

    include('states.thruk', config)
    include('states.thruk.iptables', config)
    include('states.thruk.selinux', config)

    include('states.grafana', config)
    include('states.grafana.iptables', config)

    include('states.kibana', config)
    include('states.kibana.iptables', config)

    # local elasticsearch client to load balance requests
    include('states.elasticsearch', config)
    include('states.elasticsearch.conf', config,
        cluster=cluster,
        data=False,
        master=False,
        local=True)
    include('states.elasticsearch.iptables', config,
        local=True)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config


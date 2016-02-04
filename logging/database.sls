#!py_c|stateconf -p

app = 'logging.database'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)
    cluster = domcfg['applications']['logging']['database']['cluster']
    data = appcfg.get('data', True)

    include('states.elasticsearch', config)
    include('states.elasticsearch.conf', config,
        cluster=cluster,
        data=data)
    include('states.elasticsearch.iptables', config)

    include('roles.firewall', config)

    return config

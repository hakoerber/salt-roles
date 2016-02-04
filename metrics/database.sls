#!py_c|stateconf -p

app = 'metrics.database'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)
    cluster = domcfg['applications']['metrics']['database']['cluster']
    data = appcfg.get('data', True)

    include('states.influxdb', config)
    include('states.influxdb.conf', config,
        domain=domcfg['name'],
        cluster=cluster,
        data=data)
    include('states.influxdb.iptables', config)

    include('roles.firewall', config)

    return config

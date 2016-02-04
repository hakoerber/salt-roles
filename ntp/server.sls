#!py_c|stateconf -p

app = 'ntp'

def run():
    config = prepare()

    appcfg = appconf(app)
    netcfg = appnet(appcfg)
    domcfg = appdom(appcfg)
    ifcfg = appif(appcfg)
    appdomcfg = appdomconf(domcfg, app)

    include('states.ntp', config)
    include('states.ntp.conf', config,
        network=netcfg,
        external_servers=appdomcfg.get('external_servers'),
        is_server=appcfg.get('server', False),
        servers=appdomcfg['servers'],
        authorative=appcfg.get('authorative', True),
        authorative_servers=appdomcfg['authorative_servers'])
    include('states.ntp.iptables', config,
        is_server=appcfg.get('server', False))
    include('states.ntp.logging', config)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)
    return config

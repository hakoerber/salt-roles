#!py_c|stateconf -p

app = 'dns'

def run():
    config = prepare()

    appcfg = appconf(app)
    netcfg = appnet(appcfg)
    domcfg = appdom(appcfg)
    ifcfg = appif(appcfg)
    appdomcfg = appdomconf(domcfg, app)

    parameters = {
        'role'          : appcfg['role'],
        'domain'        : domcfg['name'],
        'domain_reverse': netcfg['domain_reverse'],
        'zoneinfo'      : appdomcfg['zoneinfo'],
        'forwarders'    : appdomcfg['forwarders'],
        'dnssec'        : appdomcfg.get('dnssec', True),
        'listen'        : ifcfg['ip'],
        'master'        : appdomcfg['master'],
        'slaves'        : appdomcfg['slaves'],
        'networks'      : get_localnets(),
    }

    include('states.bind', config)
    include('states.bind.conf', config, **parameters)
    include('states.bind.zones', config, **parameters)
    include('states.bind.iptables', config)
    include('states.bind.logging', config)
    include('states.bind.logrotate', config)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

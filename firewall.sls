#!py_c|stateconf -p

def get_zones():
    zones = {
        'public': {
            'sources': ['0.0.0.0/0'],
        },
        'local': {
            'sources': get_localnets(),
        }
    }

    for network in __pillar__['networks']:
        zones.update(network.get('zones', {}))

    return zones

def run():
    config = prepare()

    if __grains__['os_family'] != 'FreeBSD':
        include('states.iptables', config)
        include('states.iptables.conf', config)
        include('states.iptables.zones', config,
            zones=get_zones())
        include('states.iptables.logging', config)

        include('roles.logging.client', config)
        include('roles.logging.local', config)
    return config

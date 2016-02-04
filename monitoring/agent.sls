#!py_c|stateconf -p

def run():
    config = prepare()

    servers = []
    for domain in __pillar__['domains']:
        servers.extend(domain.get('applications', {}).get('monitoring', {}).get('servers', []))

    include('states.nagios.check_mk.agent', config)
    include('states.nagios.check_mk.agent.conf', config,
        servers=servers)
    if __grains__['os_family'] != 'FreeBSD':
        include('states.nagios.check_mk.agent.iptables', config,
            servers=servers)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

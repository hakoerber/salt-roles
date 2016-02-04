#!py_c|stateconf -p

def get_interfaces():
    interfaces = []
    for interface in __pillar__['interfaces']:
        if not interface.get('conf', True):
            continue
        if interface.get('identifier') is None:
            continue
        name = interface.get('identifier')
        new_interface = {
            'name': name,
            'mac': interface['mac'],
            'type': interface.get('type', 'eth'),
            'mode': interface['mode']}

        if interface['mode'] == 'static':
            netinfo = get_network(interface['network'])
            dominfo = get_domain(netinfo['domain'])

            if 'gateway' in interface:
                gateway = interface['gateway']
            else:
                gateway= netinfo.get('default_gateway', None)

            new_interface.update({
                'address': interface['ip'],
                'netmask': netinfo.get('netmask', None),
                'gateway': gateway,
                'nameservers': [nameserver['ip'] for nameserver in
                                dominfo.get('applications', {})
                                .get('dns', {})
                                .get('zoneinfo', {})
                                .get('nameservers', [])]})
        interfaces.append(new_interface)
    return interfaces


def run():
    config = prepare()

    if __grains__['os_family'] == 'FreeBSD':
        return config

    primary_network = get_network(None)
    primary_domain = get_domain(None)
    hostname = '{0}.{1}'.format(__pillar__['hostname'], primary_domain['name'])


    include('states.network', config,
        hostname=hostname,
        interfaces=get_interfaces())
    include('states.hostname', config,
        hostname=hostname)

    return config

#!py|stateconf -p

from salt.exceptions import SaltRenderError

def get_hostname():
    non_vpns = {domain: net for domain, net in __pillar__.get('network', {}).items() if not net.get('vpn', False)}
    primary_domain = None
    if len(non_vpns) == 0:
        raise SaltRenderError("No domain specified.")
    if len(non_vpns) == 1:
        primary_domain = non_vpns.keys()[0]
    else:
        for domain, interface in non_vpns.items():
            if interface.get('primary', False):
                primary_domain = domain
    if primary_domain is None:
        raise SaltRenderError("No primary interface defined.")
    return '{hostname}.{domain}'.format(
        hostname=__pillar__['hostname'],
        domain=primary_domain)


def get_interfaces():
    interfaces = []
    for domain, interface in __pillar__.get('interfaces', {}).items():
        name = interface.get('identifier')
        if name is None:
            continue
        new_interface = {
            'name': name,
            'mac': interface['mac'],
            'type': interface.get('type', 'eth'),
            'mode': interface['mode']}

        if interface['mode'] == 'static':
            netinfo = __pillar__['network'].get(domain, {})
            dominfo = __pillar__['domain'].get(domain, {})

            if 'gateway' in interface:
                gateway = interface['gateway']
            else:
                gateway= netinfo['default_gateway']

            new_interface.update({
                'address': interface['ip'],
                'netmask': netinfo['netmask'],
                'gateway': gateway,
                'nameservers': [nameserver['ip'] for nameserver in
                                dominfo.get('applications', {})
                                .get('dns', {})
                                .get('zoneinfo', {})
                                .get('nameservers', [])]})
        interfaces.append(new_interface)
    return interfaces


def get_ipv6():
    return __pillar__.get('network', {}).get('ipv6', False)


def run():
    config = dict()
    if __grains__['os_family'] == 'FreeBSD':
        return config
    config['include'] = [
        'states.network',
    ]

    config['extend'] = {
        'states.network::params': {
            'stateconf.set': [
                {'hostname': get_hostname()},
                {'ipv6': get_ipv6()},
                {'interfaces': get_interfaces()}]
        },
    }

    return config

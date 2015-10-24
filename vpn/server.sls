#!py|stateconf -p

def get_vpns():
    vpns = {k: v for k, v in __pillar__.get('network').items() if v.get('vpn')}
    for vpnname, vpn in vpns.items():
        vpn['devname'] = 'vpn-{}'.format(vpnname)
    return vpns


def run():
    config = dict()
    config['include'] = [
        'states.openvpn',
        'states.openvpn.server',
        'states.openvpn.server.conf',
        'states.openvpn.server.pki',
        'states.openvpn.server.iptables',
        'states.openvpn.server.logging',
    ]

    vpns = get_vpns()

    config['extend'] = {
        'states.openvpn.server::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.server.conf::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.server.pki::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.server.iptables::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.server.logging::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
    }

    return config

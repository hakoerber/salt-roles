#!py|stateconf -p

def get_vpns():
    vpns = {k: v for k, v in __pillar__['network'].items() if v.get('vpn')}
    for vpnname, vpn in vpns.items():
        vpn['devname'] = 'vpn-{}'.format(vpnname)
    return vpns


def run():
    config = dict()
    config['include'] = [
        'states.openvpn',
        'states.openvpn.client',
        'states.openvpn.client.conf',
        'states.openvpn.client.pki',
    ]

    vpns = get_vpns()

    config['extend'] = {
        'states.openvpn.client::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.client.conf::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
        'states.openvpn.client.pki::params': {
            'stateconf.set': [{'vpns': vpns}]
        },
    }

    return config

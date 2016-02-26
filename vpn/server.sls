#!py_c|stateconf -p

from salt.exceptions import SaltRenderError

def get_vpns():
    vpns = [net for net in __pillar__['networks'] if net.get('vpn')]
    for vpn in vpns:
        vpn['devname'] = 'vpn-{}'.format(vpn['name'])
    return vpns

def run():
    config = prepare()

    vpns = get_vpns()

    include('states.openvpn', config)
    include('states.openvpn.server', config, vpns=vpns)
    include('states.openvpn.server.conf', config, vpns=vpns)
    include('states.openvpn.server.pki', config, vpns=vpns)
    include('states.openvpn.server.iptables', config, vpns=vpns)
    include('states.openvpn.server.logging', config, vpns=vpns)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

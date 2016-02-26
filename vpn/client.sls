#!py_c|stateconf -p

from salt.exceptions import SaltRenderError

def get_vpns():
    vpns = [net for net in __pillar__['networks'] if net.get('vpn')]
    for vpn in vpns:
        vpn['devname'] = 'vpn-{}'.format(vpn['name'])
        for client in vpn['clients']:
            print(client)
            fqdn = client['name'] # + '.' + get_domain(None)['name']
            client['name'] = fqdn
            print(fqdn)
            print(__grains__['id'])
            if fqdn == __grains__['id']:
                vpn['client'] = client
                print(client)
                break
        if 'client' not in vpn.keys():
            raise SaltRenderError("Client not found.")
    return vpns

def run():
    config = prepare()

    vpns = get_vpns()

    print(vpns)

    include('states.openvpn', config)
    include('states.openvpn.client', config, vpns=vpns)
    include('states.openvpn.client.conf', config, vpns=vpns)
    include('states.openvpn.client.pki', config, vpns=vpns)
    include('states.openvpn.client.iptables', config, vpns=vpns)
    include('states.openvpn.client.logging', config, vpns=vpns)
    include('states.openvpn.client.routing', config, vpns=vpns)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

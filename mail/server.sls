#!py_c|stateconf -p

app = 'mail'

def run():
    config = prepare()

    appcfg = appconf(app)

    include('states.postfix', config)
    include('states.postfix.conf', config,
        listen_remote=True,
        hostname=appcfg['subdomain'] + '.' + appcfg['domain'],
        domain=appcfg['domain'],
        relay=appcfg.get('relay', {}),
        aliases=appcfg.get('aliases', []),
        domain_authorative=appcfg.get('domain_authorative', False))
    include('states.postfix.pki', config)
    include('states.postfix.iptables', config)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

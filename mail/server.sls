#!py_c|stateconf -p

app = 'mail'

def run():
    config = prepare()

    appcfg = appconf(app)

    ssl = appcfg.get('ssl', False)

    args = {}

    if appcfg.get('submit'):
        args['submit']={
            'auth': {
                'type': 'dovecot',
                'socket': '/var/run/dovecot-auth'
            },
            'public': appcfg['submit'].get('public', False)
        }

    include('states.postfix', config)
    include('states.postfix.conf', config,
        listen_remote=True,
        hostname=appcfg['subdomain'] + '.' + appcfg['domain'],
        domain=appcfg['domain'],
        aliases=appcfg.get('aliases', []),
        domain_authorative=appcfg.get('domain_authorative', False),
        ssl=ssl,
        accept=appcfg['accept'],
        lmtp_relay={
            'socket': '/var/run/lmtp.sock'
        },
        relay_subnet=appcfg.get('relay_subnet', False),
        **args
        )
    if ssl:
        include('states.postfix.pki', config,
            ssl=ssl,
            master_dhparams=appcfg.get('master_dhparams'))
    include('states.postfix.iptables', config,
        **args)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

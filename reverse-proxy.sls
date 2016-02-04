#!py_c|stateconf -p

app = 'reverse_proxy'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)

    acme_backend = domcfg['applications']['acme']['backend']

    ssl_domains = []
    for up in appcfg.get('upstream', {}):
        ssl_domains.append({
            "name": up['servername'],
            "ssl_cert": up.get('ssl_cert', False)
        })


    include('states.nginx', config)
    include('states.nginx.conf', config,
        ipv6=appcfg.get('ipv6', False),
        reverse_proxy={
            'protocol': appcfg.get('protocols', []),
            'upstream': appcfg.get('upstream', {})
        },
        ssl={
            'simple': appcfg.get('simple_ssl', False)
        },
        acme_backend=acme_backend
    )
    include('states.nginx.iptables', config,
        ipv6=appcfg.get('ipv6', False),
        public=appcfg.get('public', False),
        http=True,
        https=('https' in appcfg.get('protocols', []))
    )
    include('states.nginx.logging', config)
    include('states.nginx.logrotate', config)
    include('states.nginx.pki', config,
        master_dhparams=appcfg.get('master_dhparams', True),
        domains=ssl_domains
    )

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

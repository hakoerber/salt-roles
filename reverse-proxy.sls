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
            "names": up['servernames'],
            "ssl_cert": up.get('ssl_cert', False)
        })

    include('states.nginx', config)
    include('states.nginx.conf', config,
        ipv6=appcfg.get('ipv6', False),
        reverse_proxy={
            'protocol': appcfg.get('protocols', []),
            'upstream': appcfg.get('upstream', {}),
            'force_https': appcfg.get('force_https', False)
        },
        ssl={
            'simple': appcfg.get('simple_ssl', False)
        },
        acme_backend=acme_backend,
        resolver='127.0.0.1'
    )
    include('states.nginx.iptables', config,
        ipv6=appcfg.get('ipv6', False),
        public=appcfg.get('public', False),
        http=True,
        https=('https' in appcfg.get('protocols', []))
    )
    include('states.nginx.selinux', config,
        network_connect=True)
    include('states.nginx.logging', config)
    include('states.nginx.logrotate', config)
    include('states.nginx.pki', config,
        master_dhparams=appcfg.get('master_dhparams', True),
        domains=ssl_domains
    )

    include('states.dnsmasq', config)
    include('states.dnsmasq.user', config)
    include('states.dnsmasq.conf.local', config,
        domain_overrides=appcfg.get('domain_overrides', []),
        read_hostsfile=False,
        read_resolv=True
    )

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

#!py_c|stateconf -p

app = 'sync'

def run():
    config = prepare()

    appcfg = appconf(app)

    include('states.owncloud', config)
    include('states.owncloud.conf', config, **appcfg)
    include('states.owncloud.logging', config)
    include('states.owncloud.selinux', config)

    include('states.nginx', config)
    include('states.nginx.conf', config,
        ipv6=False,
        reverse_proxy={
            'protocol': ['https'],
            'upstream': [
                {
                    'servernames': ['_'],
                    'url': 'http://localhost:80',
                    'additional_params': {
                        'client_max_body_size': '10G',
                        'fastcgi_buffers': '64 4K',
                        'gzip': 'off',
                    }
                }
            ]
        },
        ssl={
            'simple': True
        },
        local_status=False, # port conflict
    )
    include('states.nginx.pki', config,
        master_dhparams=False,
        domains=[
            {
                'names': ['*']
            }])
    include('states.nginx.iptables', config,
        ipv6=False,
        public=False,
        http=False,
        https=True
    )
    include('states.nginx.selinux', config,
        network_connect=True)

    include('roles.firewall', config)
    include('roles.logging.client', config)

    return config

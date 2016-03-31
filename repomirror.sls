#!py_c|stateconf -p

app = 'localrepo'

def run():
    config = prepare()

    appcfg = appconf(app)

    content = {
        'path': appcfg['path'],
        'protocol': 'http',
        'autoindex': True,
    }

    include('states.nginx', config)
    include('states.nginx.conf', config,
        static_content=content)
    include('states.nginx.logging', config)
    include('states.nginx.iptables', config,
        public=True,
        http=True,
        https=False)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

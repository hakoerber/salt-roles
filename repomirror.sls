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

    include('states.syncrepo', config)
    include('states.syncrepo.conf', config,
        base=appcfg['mirror']['base'],
        repos=appcfg['mirror']['repos'])
    include('states.syncrepo.cron', config,
        minute=appcfg['mirror']['cron']['minute'],
        hour=appcfg['mirror']['cron']['hour'])

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

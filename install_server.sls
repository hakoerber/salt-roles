#!py_c|stateconf -p

app = 'install_server'

def run():
    config = prepare()

    appcfg = appconf(app)

    include('states.cobbler', config)
    include('states.cobbler.conf', config,
        default_password=appcfg['default_password'])
    include('states.cobbler.iptables', config)
    include('states.cobbler.selinux', config)

    return config

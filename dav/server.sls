#!py_c|stateconf -p

def run():
    config = prepare()

    include('states.radicale', config)
    include('states.radicale.conf', config)
    include('states.radicale.iptables', config)
    include('states.radicale.logging', config)

    include('roles.firewall', config)

    return config

#!py_c|stateconf -p

def run():
    config = prepare()

    include('states.quassel.core', config)
    include('states.quassel.core.conf', config)
    include('states.quassel.core.tls', config)
    include('states.quassel.core.iptables', config)

    include('roles.firewall', config)

    return config

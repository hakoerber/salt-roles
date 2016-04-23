#!py_c|stateconf -p

def run():
    config = prepare()

    include('states.motd', config,
        domains=[domain['name'] for domain in pillar['domains']],
        networks=[network['name'] for network in pillar['networks']],
        roles=pillar['__reclass__']['applications'])

    return config

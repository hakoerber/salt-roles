#!py_c|stateconf -p

app = 'logging'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)
    cluster = domcfg['applications']['logging']['database']['cluster']

    listeners = appcfg['listeners']
    outputs = [{
        'type': 'elasticsearch',
        'args': {
            'hosts': [host['name'] for host in cluster['nodes']],
            'index': 'logstash-%{+YYYY.MM.dd}'},
        },
    ]

    include('states.logstash', config)
    include('states.logstash.conf', config,
        listeners=listeners,
        outputs=outputs)
    include('states.logstash.iptables', config,
        listeners=listeners)

    include('roles.firewall', config)

    return config

#!py_c|stateconf -p

def get_logservers():
    logservers = []
    for domain in __pillar__.get('domains', []):
        for logserver in domain['applications'].get('logging', {}).get('servers', []):
            logserver.update({'domain': domain['name']})
            logservers.append(logserver)
    return logservers

def run():
    config = prepare()

    include('states.rsyslog', config)
    include('states.rsyslog.conf', config)
    include('states.rsyslog.conf.client', config,
        servers=get_logservers())
    include('states.rsyslog.logrotate', config)
    return config

#!py_c|stateconf -p

app = 'monitoring'

def run():
    config = prepare()

    appcfg = appconf(app)
    domcfg = appdom(appcfg)
    appdomcfg = appdomconf(domcfg, app)

    clients = [
        {'name': client['name'] + '.' + domcfg['name'],
         'ip': client['ip'],
         'groups': [client['type']]}
        for client in appdomcfg['clients']]
    dashboard_servers = appdomcfg.get('dashboards', False)
    groups = []
    contactgroups = []
    influxdb = domcfg['applications']['metrics']['database']['cluster']
    contacts = appcfg['contacts']
    notifications = [{
        'groups': ['all'],
        'type': 'mail',
    }]

    include('states.nagios', config)
    include('states.nagios.selinux', config)
    include('states.nagios.conf', config)

    include('states.nagios.check_mk.server', config)
    include('states.nagios.check_mk.server.livestatus', config)
    include('states.nagios.check_mk.server.livestatus.export', config,
        allow_from=dashboard_servers)
    include('states.nagios.check_mk.server.conf', config,
        hosts=clients,
        groups=groups)
    include('states.nagios.check_mk.server.iptables', config)
    include('states.nagios.check_mk.server.notifications', config,
        contactgroups=contactgroups,
        contacts=contacts,
        notifications=notifications)

    include('states.nagios.graphios', config)
    include('states.nagios.graphios.conf', config,
        influxdb=influxdb)

    include('states.xinetd', config)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

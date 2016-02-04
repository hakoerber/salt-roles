#!py_c|stateconf -p

app = 'dhcp'

def run():
    config = prepare()

    appcfg = appconf(app)
    netcfg = appnet(appcfg)
    domcfg = appdom(appcfg)
    ifcfg = appif(appcfg)
    appnetcfg = appnetconf(netcfg, app)

    include('states.dhcpd', config)
    include('states.dhcpd.conf', config,
        network      = netcfg,
        role         = appcfg['role'],
        primary      = appnetcfg['failover']['primary'],
        secondary    = appnetcfg['failover']['secondary'],
        range        = appnetcfg['range'],
        reservations = appnetcfg['reservations'],
        nameservers  = domcfg['applications']['dns']['zoneinfo']['nameservers'],
        ntpservers   = domcfg['applications']['ntp']['servers'],
        domain       = domcfg['name'],
        dhcpoptions  = appnetcfg['options']
    )
    include('states.dhcpd.iptables', config,
        role         = appcfg['role'],
        primary      = appnetcfg['failover']['primary'],
        secondary    = appnetcfg['failover']['secondary']
    )
    include('states.dhcpd.logging', config)

    include('roles.firewall', config)
    include('roles.logging.client', config)
    include('roles.logging.local', config)

    return config

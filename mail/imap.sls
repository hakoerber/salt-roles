#!py_c|stateconf -p

app = 'mail'

def run():
    config = prepare()

    appcfg = appconf(app)

    # user -> user@domain
    users = appcfg['users']
    for user in users:
        user['name'] = '{name}@{domain}'.format(
            name=user['name'],
            domain=appcfg['domain'])

    include('states.dovecot', config)
    include('states.dovecot.conf', config,
        lmtp_socket={
            'user': 'postfix',
            'group': 'postfix'
        },
        auth_socket={
            'user': 'postfix',
            'group': 'postfix'
        },
        users=users)
    include('states.dovecot.pki', config)
    include('states.dovecot.iptables', config)

    include('roles.firewall', config)

    return config

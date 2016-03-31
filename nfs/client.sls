#!py_c|stateconf -p

app = 'nfs.client'

def run():
    config = prepare()

    appcfg = appconf(app)

    include('states.nfs.client', config)
    include('states.nfs.mount', config,
        mounts=appcfg['mounts'])
    include('states.nfs.selinux', config,
        homedirs_on_nfs=appcfg.get('homedirs_on_nfs', False))

    return config

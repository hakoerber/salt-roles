#!py_c|stateconf -p

def run():
    config = prepare()

    if __grains__['os_family'] != 'RedHat':
        return config

    localmirrors = []
    for domain in __pillar__['domains']:
        for dommirror in domain['applications'].get('localrepo', {}).get('servers', []):
            dommirror['domain'] = domain['name']
            localmirrors.append(dommirror)

    # this is now a mapping from
    #     server -> [repos]
    # but we need
    #     repo -> [servers]
    localrepos = {}
    for mirror in localmirrors:
        for name, repo in mirror['repos'].items():
            if name in localrepos.keys():
                continue
            newmirror = mirror['repos'][name]
            newmirror['name'] = mirror['name']
            newmirror['domain'] = mirror['domain']
            mirrors = [newmirror]
            for othermirror in localmirrors:
                if othermirror is mirror:
                    continue
                if name in othermirror['repos'].keys():
                    newmirror = othermirror['repos'][name]
                    newmirror['name'] = othermirror['name']
                    newmirror['domain'] = othermirror['domain']
                    mirrors.append(newmirror)
            localrepos[name]=mirrors

    include('states.repo.epel', config)
    include('states.repo.local', config,
        localrepos=localrepos)

    return config

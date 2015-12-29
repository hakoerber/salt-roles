#!py|stateconf -p

def get_localrepos():
    localmirrors = []
    domains = pillar.get('interfaces', {}).keys()
    for domain in domains:
        domdata = pillar['domain'].get(domain, {})
        dommirrors = domdata.get('applications', {}).get('localrepo', {}).get('servers', [])
        for dommirror in dommirrors:
            dommirror['domain'] = domain
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
    return localrepos

def run():
    config = dict()
    if grains['os_family'] != 'RedHat':
        return config

    config['include'] = [
        'states.repo.epel',
        'states.repo.local',
    ]

    config['extend'] = {
        'states.repo.local::params': {
            'stateconf.set': [{'localrepos': get_localrepos()}]
        },
    }

    return config

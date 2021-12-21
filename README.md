# NMODL Database and Generator

This repository stores all NMODL models (>6300 mod files) parsed by [NMODL Framework](https://github.com/BlueBrain/nmodl).

For more information, see this issue : [BlueBrain/nmodl/issues/192](https://github.com/BlueBrain/nmodl/issues/192)

## Installing dependencies

We use tox for dependency management and script execution. That means, the only thing you need to
install yourself is tox:

```
pip install tox
```

## syncing / downloading DBs


Downloading modeldb is done with:

```
tox -e download-modeldb
```

Downloading BBP's models is done with:

```
tox -e download-bbpdb
```

> There is a catch, though. You need to have access to BBPs internal repositories and you need a
> special YAML config file. If you are not BBP HPC Team, you will probably not have the appropriate
> access.


### First-time download

The default for maximum number of file downloads is set to 25, this is to avoid large numbers of
requests hammering the modeldb server. For the initial download you can use :

```
tox -e init-modeldb
```

to pass to the `dbgen.py` script the extra argument to fetch up to 2000 models.

### Other operations

To clean/remove existing databases:
```
tox -e clean-db
```

To clean/remove existing cache:
```
tox -e clean-cache
```

To test-build all mods in modldb:
```
tox -e test-modldb
```

To test-build all BBP mods:
```
tox -e test-bbpdb
```


License
-------

See [NMODL](https://github.com/BlueBrain/nmodl)

Funding
-------

(N.B. this work is part of the NMODL project)

NMODL is developed in a joint collaboration between the Blue Brain Project and Yale University. This work is supported by funding to the Blue Brain Project, a research center of the École polytechnique fédérale de Lausanne (EPFL), from the Swiss government’s ETH Board of the Swiss Federal Institutes of Technology, NIH grant number R01NS11613 (Yale University), the European Union Seventh Framework Program (FP7/20072013) under grant agreement n◦ 604102 (HBP) and the European Union’s Horizon 2020 Framework Programme for Research and Innovation under Specific Grant Agreement n◦ 720270 (Human Brain Project SGA1), n◦ 785907 (Human Brain Project SGA2) and n◦ 945539 (Human Brain Project SGA3).

Copyright (c) 2016 - 2021 Blue Brain Project/EPFL

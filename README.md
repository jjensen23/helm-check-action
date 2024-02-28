# Description [![Version](https://img.shields.io/badge/version-v1.1.0-color.svg)](https://github.com/jjensen23/helm-check-action/releases/tag/v1.1.0)

Fork of: https://github.com/igabaydulin/helm-check-action with functionality for additional values files.

helm-check is a [github action](https://github.com/features/actions) tool which allows to prevalidate helm chart
template before its deployment; executes [helm lint](https://helm.sh/docs/helm/#helm-lint) and [helm template](https://helm.sh/docs/helm/#helm-template)
commands

## Table of Contents
* [Components](#components)
* [Environment Variables](#environment-variables)
* [Sample](#sample)
* [Output Example](#output-example)
* [Testing](#testing)

## Components
* `Dockerfile`: contains docker image configuration
* `entrypoint.sh`: contains executable script for helm templates validation

## Environment variables
* `CHART_LOCATION`: chart folder; required field for `helm lint` and `helm template` executions
* `CHART_VALUES`: custom values file for specific kubernetes environment; required field for `helm template` execution
* `CHART_VALUES_DIR`: location where additional values files are stored; optional

## Sample
```
on: push
name: Main
jobs:
  helm-check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: helm-check
      uses: jjensen23/helm-check-action@v1.1.0
      env:
        CHART_LOCATION: charts/exhibit-service
        CHART_VALUES: charts/exhibit-service/values.yaml
        CHART_VALUES_DIR: charts/exhibit-service/dev
```

## Testing
You can test script locally, but make sure you have all needed tools (helm at least); next steps describe how 
to test action on Linux system:

1. Clone action repository
1. Make sure entrypoint.sh is executable, otherwise execute next command in terminal:

    ```
    igabaydulin@localhost:~/dev/helm-check-action$ chmod +x ./entrypoint.sh
    ```
1. Move to your repository and execute next command in terminal:

    ```
    igabaydulin@localhost:~/dev/my-local-repository$ CHART_LOCATION=/path/to/chart CHART_VALUES=/path/to/values/values.yaml /path/to/entrypoint.sh
    ```
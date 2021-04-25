#!/usr/bin/env bash -euo pipefail

env

docker run --network container:webapp-frontend appropriate/curl -s --retry 10 --retry-connrefused http://localhost:5000/

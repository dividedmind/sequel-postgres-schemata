#!/bin/bash
set -xeu

docker-compose up \
    --exit-code-from tests

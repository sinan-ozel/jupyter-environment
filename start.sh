#!/bin/bash

redis-server --daemonize yes
jupyter lab --ip=0.0.0.0 --port=8888 --user=root--allow-root
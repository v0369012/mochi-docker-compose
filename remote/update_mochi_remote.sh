#!/bin/bash
docker rmi dockerjjz/mochi_remote
docker rmi mochi_remote
docker build -t mochi_remote . --no-cache
docker tag mochi_remote dockerjjz/mochi_remote

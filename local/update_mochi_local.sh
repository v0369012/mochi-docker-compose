#!/bin/bash
docker rmi dockerjjz/mochi_local
docker rmi mochi_local
docker build -t mochi_local . --no-cache
docker tag mochi_local dockerjjz/mochi_local

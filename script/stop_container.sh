#!/bin/bash
docker kill my-node-app || true
docker rm my-node-app || true
docker system prune -f

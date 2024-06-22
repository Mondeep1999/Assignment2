#!/bin/bash
cd /home/ubuntu/Assignment_node_app
git pull origin main
docker build -t hello-node-image .

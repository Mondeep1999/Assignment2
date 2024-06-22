#!/bin/bash


cd /home/ubuntu/Assignment_Node_App
docker build -t hello-node-image .
docker kill my-node-app
docker system prune
docker run --name my-node-app -d -p 3000:3000 hello-node-image

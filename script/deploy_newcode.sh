#!/bin/bash


cd ~/Assignment2
git pull origin main
docker build -t hello-node-image .
docker kill my-node-app
docker system prune
docker run --name my-node-app -d -p 3000:3000 hello-node-image

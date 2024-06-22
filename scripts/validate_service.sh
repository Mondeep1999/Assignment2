#!/bin/bash
# Check if the application is running by making an HTTP request
curl -f http://localhost:3000/ || exit 1

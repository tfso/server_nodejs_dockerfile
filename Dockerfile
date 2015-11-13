FROM ubuntu:latest
RUN apt-get update && apt-get install -y nodejs npm \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
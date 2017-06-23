#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
 
# Install prerequisites
RUN apt-get update
RUN apt-get install curl build-essential libssl-dev git -y

# Install MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    groupadd -r mongodb && useradd -r -g mongodb mongodb && \
    apt-get install -y mongodb-org

# Install Node.js
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
RUN source ~/.nvm/nvm.sh; \
    nvm install node && \
    nvm use node && \
    npm install -g node-gyp

# Install Wiki.js
RUN mkdir -p /var/www/wiki
WORKDIR /var/www/wiki
RUN source ~/.nvm/nvm.sh; \
    npm install wiki.js@latest

# Run configure
#RUN node wiki configure

RUN mkdir -p /data/db
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80

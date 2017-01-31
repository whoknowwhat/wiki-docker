#Download base image ubuntu 16.04
FROM ubuntu:16.04
 
# Update Software repository
RUN apt-get update

# Install Build Tools
RUN apt-get install -y build-essential libssl-dev

# Install MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN apt-get install mongo
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN service mongod start

# Install Node.js
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
RUN source ~/.profile
RUN nvm install node
RUN nvm use node
RUN npm install -g node-gyp

# Install Wiki.js
RUN mkdir /var/www/wiki
WORKDIR /var/www/wiki
ADD https://github.com/Requarks/wiki/releases/download/v1.0-beta.2/wiki-js.tar.gz
RUN npm install --only=production && npm rebuild

# Run as a service
RUN npm install -g pm2
RUN pm2 start server.js -n wiki

EXPOSE 80
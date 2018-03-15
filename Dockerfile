# use a node base image
FROM node:7-onbuild

# Set the working directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# set maintainer
LABEL maintainer "ben.conway@bemo.co"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:3000/api || exit 1

# tell docker what port to expose
EXPOSE 3000

CMD ["npm", "start"]

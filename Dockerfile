FROM node:18-alpine AS builder
#Create app directory as app on frontend container of docker with docker
WORKDIR /usr/src/app
#Right side ko chae docker container ko directory ho ra tesma chae local frontend file ko package json file lai copy gareko 
COPY package.json ./
RUN npm install
#Yesle chai local ko sabai file haru lai docker container ko app directory ma copy garne kam garcha
COPY . .

#appgroup -S appgroup created the appgroup command create a new system group named appgroup
#-S flag indicates that it is a system group and doesnt have a home directory
#The adduser -S appuser -G appgroup command creates a new system user named appuser and assigns it to the appgroup.
#The -S flag ensures that this is a system user, which is lightweight and does not have a home directory.
#The -G appgroup flag specifies that the user should belong to the appgroup.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/src/app
USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8000/api/health || exit 1

  CMD ["node", "server.js"]



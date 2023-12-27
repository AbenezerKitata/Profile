FROM node:20.9.0-alpine

WORKDIR /app

# Install Git and SSH client
RUN apk update && \
    apk upgrade && \
    apk add --no-cache git openssh-client

# Copy SSH files to /root/.ssh/ and remove the original .ssh folder
COPY .ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa && \
    rm -rf .ssh/

# Configure Git to use SSH
RUN echo "StrictHostKeyChecking no" > /root/.ssh/config

# Continue with the rest of your Dockerfile...
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

ARG GIT_USER
ARG GIT_EMAIL

# Set environment variables for Git
ENV GIT_USER=$GIT_USER \
    GIT_EMAIL=$GIT_EMAIL

CMD ["sh", "-c", "git config --global user.name \"$GIT_USER\" && git config --global user.email \"$GIT_EMAIL\" && npm run dev"]

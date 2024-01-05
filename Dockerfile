# Use an official Node runtime as a base image
FROM node:18.16.1-bullseye as json-copier

# Set the working directory in the container
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# Copy package.json and yarn.lock to the working directory
COPY ["package.json", "yarn.lock", "preinstall.js", "./"]
COPY extensions /usr/src/app/extensions
COPY modes /usr/src/app/modes
COPY platform /usr/src/app/platform


FROM node:18.16.1-bullseye as builder
RUN apt-get update && apt-get install -y build-essential python3
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY --from=json-copier /usr/src/app .

# Install project dependencies
RUN yarn config set workspaces-experimental true
RUN yarn install --frozen-lockfile --verbose

# Copy the rest of the application code
COPY . .

# To restore workspaces symlinks
RUN yarn install --frozen-lockfile --verbose

ENV PATH /usr/src/app/node_modules/.bin:$PATH
ENV QUICK_BUILD true

RUN yarn run build

# Expose the port on which the application will run (if applicable)
EXPOSE 3000

# Specify the command to run on container start
CMD ["yarn", "start"]

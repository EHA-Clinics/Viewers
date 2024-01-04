# Use an official Node runtime as a base image
FROM node:18.16.1-bullseye

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock to the working directory
COPY package.json yarn.lock ./

# Install project dependencies
RUN yarn install --frozen-lockfile --production

# Copy the rest of the application code
COPY . .

# Expose the port on which the application will run (if applicable)
# EXPOSE 3000

# Specify the command to run on container start
CMD ["yarn", "start"]

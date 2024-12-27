# Use a base Debian image
FROM debian:latest

# Use an appropriate base image that includes Node.js (e.g., official Node.js image)
FROM node:21.1.0

# Install necessary dependencies and Chromium
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    chromium

# Verify that Chromium was installed successfully
RUN which chromium

# Optionally, you can check the Chromium version
RUN chromium --version
# Set work directory
WORKDIR /app

# Copy the package.json and package-lock.json (if available)
COPY package*.json ./


# Install app dependencies
RUN npm install

# Copy application files
COPY . .


# Expose port and run the app
EXPOSE 3000
CMD ["node", "index.js"]

# Use a base Debian image
FROM debian:latest

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

# Copy application files
COPY . .

# Install app dependencies
RUN npm install

# Expose port and run the app
EXPOSE 3000
CMD ["node", "index.js"]

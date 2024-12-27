# Use an official Node.js runtime as a parent image
FROM node:18

# Install dependencies for Chromium
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    chromium-browser

# Install Chromium (stable)
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | tee /etc/apt/trusted.gpg.d/google.asc \
    && sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google.asc] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y chromium-browser

RUN apt-get update && apt-get install -y chromium
# Verify Chromium installation (this will print the path of Chromium)
RUN chromium-browser --version
RUN find / -name chromium-browser
RUN which chromium || which chromium-browser


# Set work directory
WORKDIR /app

# Copy application files
COPY . .

# Install app dependencies
RUN npm install

# Expose port and run the app
EXPOSE 3000
CMD ["node", "index.js"]

# Use an official Node.js runtime as a parent image
FROM node:18

# Install dependencies for Chromium
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    ca-certificates \
    chromium-browser \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxi6 \
    libgdk-pixbuf2.0-0 \
    libnss3 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libxrandr2 \
    libgbm1 \
    libnspr4 \
    fonts-liberation \
    libappindicator3-1 \
    libu2f-udev \
    libv4l-0 \
    libxshmfence1 \
    xdg-utils \
    --no-install-recommends

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

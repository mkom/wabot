# Use an appropriate base image that includes Node.js (e.g., official Node.js image)
FROM node:21-slim

# Install dependencies and Google Chrome
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
    # Install dependencies for Puppeteer
    && apt-get install -y \
        ca-certificates \
        fonts-liberation \
        libappindicator3-1 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libgdk-pixbuf2.0-0 \
        libnspr4 \
        libnss3 \
        libx11-xcb1 \
        libxcomposite1 \
        libxrandr2 \
        xdg-utils \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Install app dependencies
RUN npm install puppeteer@23.11.1

# Run everything after as non-privileged user.
USER pptruser

CMD ["google-chrome-stable"]

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

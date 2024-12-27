# Use a base Debian image
FROM debian:latest

# Use an appropriate base image that includes Node.js (e.g., official Node.js image)
FROM node:18-slim

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


RUN npm init -y &&  \
    npm i  puppeteer-core@23.11.1 \
    npm i mongoose@8.9.2 \
    npm i whatsapp-web.js@1.26.0 \
    npm i express@4.21.2 \
    npm i cors@2.8.5 \
    npm i dotenv@16.4.7 \
    npm i qrcode-terminal@0.12.0 \
    npm i wwebjs-mongo@1.1.0 \
    # Add user so we don't need --no-sandbox.
    # same layer as npm install to keep re-chowned files from using up several hundred MBs more space
    && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules \
    && chown -R pptruser:pptruser /package.json \
    && chown -R pptruser:pptruser /package-lock.json

# Run everything after as non-privileged user.
USER pptruser

CMD ["google-chrome-stable"]

# Set work directory
WORKDIR /app

# Copy the package.json and package-lock.json (if available)
#COPY package*.json ./


# Install app dependencies
RUN npm install

# Copy application files
COPY . .


# Expose port and run the app
EXPOSE 3000
CMD ["node", "index.js"]

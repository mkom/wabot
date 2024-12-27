# Menggunakan image Node.js resmi
FROM node:18

# Install dependencies untuk Chromium
RUN apt-get update && apt-get install -y wget gnupg2 curl
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y chromium

# Salin aplikasi Anda ke dalam kontainer
COPY . /app

WORKDIR /app

# Install dependencies aplikasi
RUN npm install

# Jalankan aplikasi Anda
CMD ["node", "index.js"]

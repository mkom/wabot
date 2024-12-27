# Menggunakan image dasar dari Node.js versi LTS
FROM node:18-slim

# Membersihkan cache apt dan memperbarui repositori
RUN apt-get clean && apt-get update --fix-missing

# Install dependensi untuk Chromium
RUN apt-get install -y \
    wget \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libgobject-2.0-0 \
    libgbm1 \
    --no-install-recommends

# Set direktori kerja di dalam container
WORKDIR /usr/src/app

# Menyalin file package.json dan package-lock.json (jika ada)
COPY package*.json ./

# Menginstal dependensi aplikasi
RUN npm install

# Menyalin seluruh kode aplikasi ke dalam container
COPY . .

# Mengekspos port aplikasi (Jika Anda menggunakan Express)
EXPOSE 3000

# Menjalankan aplikasi
CMD ["node", "index.js"]

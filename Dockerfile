# Menggunakan image dasar dari Node.js versi LTS
FROM node:18-slim

# Set direktori kerja di dalam container
WORKDIR /usr/src/app

# Menyalin file package.json dan package-lock.json (jika ada)
COPY package*.json ./

# Menginstal dependensi
RUN npm install

# Menyalin seluruh kode aplikasi ke dalam container
COPY . .

# Mengekspos port aplikasi (Jika Anda menggunakan Express)
EXPOSE 3000

# Menjalankan aplikasi
CMD ["node", "index.js"]

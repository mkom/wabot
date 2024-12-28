const { Client, LocalAuth } = require('whatsapp-web.js');
const express = require('express');
const cors = require('cors');
const qrcode = require('qrcode-terminal');
require('dotenv').config();
const puppeteer = require('puppeteer');

const app = express();
app.use(express.json()); 

// CORS configuration
const corsOptions = {
    origin: ['https://rt5vc.vercel.app', 'http://localhost:3000'], // Replace with your allowed origin
    methods: 'GET, POST, PUT, DELETE, OPTIONS',
    allowedHeaders: 'Content-Type, Authorization',
};
  
app.use(cors(corsOptions));

//Membuat instance client dengan autentikasi lokal
const client = new Client({
    puppeteer: { args: ["--no-sandbox", "--disable-dev-shm-usage"] },
    authStrategy: new LocalAuth({ clientId: "client-id", dataPath: './my-session' }) // Menggunakan autentikasi lokal untuk menyimpan sesi
});


// Menampilkan QR code untuk autentikasi
client.on('qr', (qr) => {
    qrcode.generate(qr, { small: true });
});

client.on('ready', () => {
    console.log('Client is ready!');

    // Mengirim pesan setelah siap
    const number = process.env.ADMIN_NUMBER; // Ganti dengan nomor tujuan
    const message = 'Hello, this is a test message from my bot!';

    // Format nomor: gunakan kode negara tanpa tanda "+" (misalnya untuk Indonesia: 6281234567890)
    client.sendMessage(`${number}@c.us`, message)
        .then(response => {
            console.log('Message sent:', response);
        })
        .catch(err => {
            console.error('Error sending message:', err);
        });


});

client.on('authenticated', () => {
    console.log('WhatsApp client authenticated');
});

client.on('auth_failure', (msg) => {
    console.log('Authentication failure:', msg);
});

client.on('disconnected', (reason) => {
    console.log('WhatsApp client disconnected:', reason);
});

// Menjalankan server pada port tertentu (misalnya 4001)
app.listen(4001, () => {
    console.log('Server running on port 4001');
});

// Menjalankan client
client.initialize()
    .then(() => console.log('Client initialization started successfully'))
    .catch(err => console.error('Error initializing WhatsApp client:', err));

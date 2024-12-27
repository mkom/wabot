const { Client, LocalAuth } = require('whatsapp-web.js');
const express = require('express');
const cors = require('cors');
const qrcode = require('qrcode-terminal');
require('dotenv').config();
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({
        executablePath: process.env.CHROMIUM_PATH || '/usr/bin/chromium-browser', // Ensure this path is correct
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
      });

  const page = await browser.newPage();
  await page.goto('https://example.com');
  console.log(await page.title());
  await browser.close();
})();

//Membuat instance client dengan autentikasi lokal
const client = new Client({
    authStrategy: new LocalAuth({ clientId: "client-id", dataPath: './my-session' }) // Menggunakan autentikasi lokal untuk menyimpan sesi
});

const app = express();
app.use(express.json());  // Menggunakan middleware untuk parsing JSON

// CORS configuration
const corsOptions = {
    origin: ['https://rt5vc.vercel.app', 'http://localhost:3000'], // Replace with your allowed origin
    methods: 'GET, POST, PUT, DELETE, OPTIONS',
    allowedHeaders: 'Content-Type, Authorization',
};
  
  app.use(cors(corsOptions));

// Menampilkan QR code untuk autentikasi
client.on('qr', (qr) => {
    qrcode.generate(qr, { small: true });
});

// Menyambung ke WhatsApp
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

//endpoint kirim pesan
app.post('/api/notify', (req, res) => {
    const { number, bodyMessage } = req.body;

    if (!number || !bodyMessage) {
        return res.status(400).json({ success: false, message: 'Nomor  dan detail transaksi diperlukan.' });
    }
    const decodedBodyMessage = decodeURIComponent(bodyMessage);
     const message = `${decodedBodyMessage}`;
    client.sendMessage(`${number}@c.us`, message)
        .then(() => {
            res.status(200).json({ success: true, message: 'Pesan terkirim ke '+number });
        })
        .catch((err) => {
            console.error(err);
            res.status(500).json({ success: false, message: 'Gagal mengirim Pesan ke '+number});
        });
});


// Mendengarkan pesan masuk
client.on('message', message => {
    console.log(message.body);
});

// Menjalankan server pada port tertentu (misalnya 4001)
app.listen(4001, () => {
    console.log('Server running on port 4001');
});

// Menjalankan client
client.initialize();
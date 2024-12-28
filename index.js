const { Client, RemoteAuth } = require('whatsapp-web.js');
const { MongoStore } = require('wwebjs-mongo');
const mongoose = require('mongoose');
const qrcode = require('qrcode-terminal');
require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
app.use(express.json());  // Menggunakan middleware untuk parsing JSON

// CORS configuration
const corsOptions = {
    origin: ['https://rt5vc.vercel.app', 'http://localhost:3000'], // Replace with your allowed origin
    methods: 'GET, POST, PUT, DELETE, OPTIONS',
    allowedHeaders: 'Content-Type, Authorization',
};

app.use(cors(corsOptions));
  

mongoose.connect(process.env.MONGODB_URI).then(() => {
    console.log('Connected to MongoDB!');
    const store = new MongoStore({ mongoose: mongoose });
    const client = new Client({
        puppeteer: { args: ["--no-sandbox", "--disable-dev-shm-usage"] },
        authStrategy: new RemoteAuth({
            store: store,
            dataPath:'./.wwebjs_auth/',
            backupSyncIntervalMs: 300000
        })
    });

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

    client.on('authenticated', (session) => {
        console.log('Session authenticated:', session);
    });
    
    client.on('auth_failure', (msg) => {
        console.log('Authentication failure:', msg);
    });
    
    client.on('disconnected', (reason) => {
        console.log('WhatsApp client disconnected:', reason);
    });

    client.on('error', (error) => {
        console.error('Error occurred:', error);
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

    client.initialize()
    .then(() => console.log('Client initialization started successfully'))
    .catch(err => console.error('Error initializing WhatsApp client:', err));
});

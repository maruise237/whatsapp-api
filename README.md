# Unofficial WhatsApp API for n8n

A lightweight unofficial WhatsApp API built with whatsmeow, designed to integrate WhatsApp with n8n.

It delivers incoming WhatsApp messages (text and voice notes) to n8n webhooks, and exposes a simple HTTP endpoint that n8n can call to send messages back.

![n8n Workflow Example](./screenshot/1.png)

## ✨ Features
- Receive WhatsApp messages → forward to webhook (text + voice notes).
- Send WhatsApp messages via POST /send.
- Basic Auth protection for webhooks and API.
- Persistent session with SQLite.
- QR code pairing for WhatsApp login.

## ⚙️ Requirements
- WhatsApp account (to scan QR code)
- n8n instance for automation

## 🚀 Setup
- Download Binary from Releases
- Create .env:

```ini
TEXT_WEBHOOK_URL=http://localhost:8080/webhook/whatsapp
VOICE_WEBHOOK_URL=http://localhost:8080/webhook/whatsapp/voice
WEBHOOK_USER=youruser
WEBHOOK_PASS=yourpass
LISTEN_ADDR=0.0.0.0:1012
# Optional:
# PORT=1012
# DB_PATH=session.db
```

- Run:

```bash
./whatsappapi-linux-amd64
```

NOTE: On first run, scan the displayed QR code in WhatsApp to pair the device.

## 🐳 Docker Deployment

You can run this API using Docker for better persistence and isolation.

```bash
docker build -t whatsapp-api-server .
docker run -d \
  --name whatsapp-api \
  -v $(pwd)/session.db:/app/session.db \
  -e TEXT_WEBHOOK_URL=... \
  -e VOICE_WEBHOOK_URL=... \
  -e WEBHOOK_USER=... \
  -e WEBHOOK_PASS=... \
  -e LISTEN_ADDR=0.0.0.0:1012 \
  -p 1012:1012 \
  whatsapp-api-server
```

## ☁️ Cloud Deployment

### Vercel
This project includes a `vercel.json` for deployment on Vercel using the Go runtime.
**Note:** Since WhatsApp requires a persistent WebSocket connection, serverless environments like Vercel may have limitations. For a more stable experience, use a persistent server (VPS, Docker, Railway, etc.).

### Railway / Render
These platforms are recommended as they support persistent long-running processes. They will automatically detect the `Dockerfile` or use the Go build process.


## 📡 API

Send a Message
```
POST /send
Authorization: Basic base64(user:pass)
Content-Type: application/json

{
  "number": "1234567890",
  "text": "Hello from n8n!"
}
```

## 🔗 n8n Integration
- Configure Webhook nodes in n8n to capture messages from TEXT_WEBHOOK_URL and VOICE_WEBHOOK_URL.
- Use the /send endpoint to reply to WhatsApp messages programmatically.


## ⚠️ Notes
- This is unofficial and not affiliated with WhatsApp.
- Use responsibly to avoid account bans.
- For production: run behind reverse proxy + HTTPS.


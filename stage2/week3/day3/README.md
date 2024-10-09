Tasks :
- Setup node-exporter, prometheus dan Grafana menggunakan docker / native diperbolehkan
- monitoring seluruh server yang kalian buat di materi terraform dan yang kalian miliki di biznet.
- Reverse Proxy
    - bebas ingin menggunakan nginx native / docker
    - Domain
      - exporter-$name.studentdumbways.my.id (node exporter)
      - prom-$name.studentdumbways.my.id (prometheus)
      - monitoring-$name.studentdumbways.my.id (grafana)
    - SSL Cloufflare on / certbot SSL biasa / wildcard SSL diperbolehkan
- Dengan Grafana, buatlah :
    -  Dashboard untuk monitor resource server (CPU, RAM & Disk Usage)  buatlah se freestyle kalian.
    -  Buat dokumentasi tentang rumus `promql` yang kalian gunakan
    -  Buat alerting dengan Contact Point pilihan kalian (discord, telegram, slack dkk)
    -  Untuk alert :
         - Boleh menggunakan alert manager / alert rule dari grafana
         - Ketentuan alerting yang harus dibuat
           - CPU Usage over 20%
           - RAM Usage over 75%
    -  Monitoring specific container
	 - deploy application frontend di app-server
         - monitoring frontend container
- untuk alerting bisa di check di server discord yaa, sudah di buatkan channel alerting


# 1. Nginx Konfigurasi
```
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

upstream grafana {
    server 103.127.136.49:3000;
}

server {
    listen 80;
    listen [::]:80;
    server_name monitoring.dody.studentdumbways.my.id;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name monitoring.dody.studentdumbways.my.id;

    ssl_certificate /etc/letsencrypt/live/monitoring.dody.studentdumbways.my.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/monitoring.dody.studentdumbways.my.id/privkey.pem;

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://grafana;
    }

    location /api/live/ {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://grafana;
    }
}
```

# 2. Konfigurasi Prometheus
```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node_exporter:9100']
```
![image](https://github.com/user-attachments/assets/d985613f-9186-4e36-b998-f730c0be9f7f)


# 3. Docker Compose
Buat file docker-compose.yml di direktori utama
```
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    volumes:
      - ./prometheus:/etc/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped

  node_exporter:
    image: prom/node-exporter
    container_name: node_exporter
    ports:
      - "9100:9100"
    restart: unless-stopped

  grafana:
    image: grafana/grafana
    container_name: grafana
    volumes:
      - grafana-data:/var/lib/grafana
    ports:
      - "3000:3000"
    restart: unless-stopped

volumes:
  grafana-data:
```

Jalankan Monitoring
```
# jalankan docker compose
docker-compose up -d

# Akses Grafana
http://localhost:3000

# user akses
Username: admin
Password: admin (kemudian akan di reset password baru sesuai keinginan)
```
![image](https://github.com/user-attachments/assets/8088c571-4319-4524-ae77-3f23d4d8d487)


# 4. Generate SSL grafana
1. Instal Certbot
```
# update package
sudo apt update

#install certbot
sudo apt install certbot
sudo apt install python3-certbot-nginx
```
2. generate ssl dengan cerbot

pertama buat domain

![image](https://github.com/user-attachments/assets/4b88eeec-e292-4a66-8961-b37ed79f1c2c)

```
sudo certbot --nginx -d <domaingrafana>
```
![image](https://github.com/user-attachments/assets/59c63bbf-69ee-4fc8-a718-d773ca141cdf)
![image](https://github.com/user-attachments/assets/3af81bd9-5675-4f47-90b9-4a924b3b07a6)
![image](https://github.com/user-attachments/assets/75510271-326a-4d33-8dd8-95f1fd76f33b)
![image](https://github.com/user-attachments/assets/5bcd9cb8-4837-4fd4-9523-04d35cc3fa61)
![image](https://github.com/user-attachments/assets/603f72d8-b12a-491d-b5e6-15ee47a38622)
![image](https://github.com/user-attachments/assets/b2ed1c0d-782c-46b0-a517-92605ee0b62f)
![image](https://github.com/user-attachments/assets/f02911f0-3472-4380-8df5-5a5c4534fc08)



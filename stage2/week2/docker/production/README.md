# Production
1. Siapkan 4 buah server untuk environment production

   ![image](https://github.com/user-attachments/assets/e85bdc9c-b4d1-4fa2-aa88-2055070bd0a0)
   ![image](https://github.com/user-attachments/assets/fc2a6614-e292-4071-9090-6c377bc96f4e)

2. Buat User Baru Untuk Setiap Server - Team2
```
# Menambahkan user
sudo adduser team2-xxx

# Menambahkan user baru agar punya sudo (super user do)
sudo usermod -aG sudo team2-xxx
```

- Server Database

![image](https://github.com/user-attachments/assets/b505be52-642f-40ea-9e46-59be9b272a74)

- Server Backend

![image](https://github.com/user-attachments/assets/75b3808e-2a1e-4981-a9c7-0fe3363ebff0)

- Server Frontend
![image](https://github.com/user-attachments/assets/af8bf900-2e57-4fda-b27f-d2135eb3560e)

- Webserver

![image](https://github.com/user-attachments/assets/8293b42b-7e4b-4db3-a391-591241d99862)

3. Instal Docker dengan Bash Script di setiap server
- buat file .sh untuk menampung script
```
nano install_docker.sh
```
![image](https://github.com/user-attachments/assets/b6b84009-cd2f-4f83-9a84-834850d56fc3)

- jalankan ```sudo chmod +x <nama_script.sh>``` untuk membuat file script kita bisa di execute
- jalankan script dengan menggunakan command berikut
```
# run script
sudo sh install-docker.sh

# atau
sudo ./install-docker.sh
```

4. Server Database
- Buat direktori untuk dijadikan volume
```
mkdir db-literature
```

- Buat docker-compose.yaml di server database, jangan lupa untuk pasang volume yang sudah kita buat tadi
```
nano docker-compose.yaml
```
kemudian isi scriptnya sebagai berikut
```
services:
  db:
    image: mysql:5.7
    container_name: db_production
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: Thebe@tles45
      MYSQL_USER: team2
      MYSQL_USER_PASSWORD: Thebe@tles45
      MYSQL_DATABASE: literature
    volumes:
      - ./db-literature:/var/lib/mysql
      - ./init-db:/docker-entrypoint-initdb.d/
    ports:
      - "3306:3306"
```

- Menjalankan docker compose dengan perintah:
```
docker compose up -d
```
- Check apakah container sudah berjalan dengan sukses
```
docker compose ps -a
```
- Check apakah container sudah berjalan dengan sukses

![image](https://github.com/user-attachments/assets/a396ba3f-56f9-4342-9cd6-d88bae3f9239)


5. Server Backend
- Konfigurasikan backend agar dapat terhubung ke database kita tadi

  ![image](https://github.com/user-attachments/assets/3fce0790-5a2a-4a79-be7c-7ccb43a73a20)

- Di file package.json, saya menambahkan script untuk menjalankan migrate database dengan sequelize-cli
```
"scripts": {
    "start": "nodemon server.js",
    "migrate": "sequelize-cli db:migrate"
  },
```
![image](https://github.com/user-attachments/assets/b3043cdc-0444-4b3b-8db3-884e4dd6d134)

- Buat Dockerfile untuk build image | Pastikan size image sekecil mungkin dengan multistage build
```
FROM node:16-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN npm install nodemon

COPY . .

RUN npm run migrate


#Build

FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app .

CMD ["npm", "start"]

EXPOSE 5000
```

- Build image yang sudah dibuat
```
docker build -t team2/literature/backend:production . 
```
![image](https://github.com/user-attachments/assets/719198df-026d-4d30-82fa-a8bb1820447e)

- Buat file compose untuk mengkonfigurasi layanan-layanan yang dibutuhkan dalam aplikasi dan menjalankannya dengan satu perintah
```
nano docker-compose.yam
```
isilah sebagai berikut
```
services:

  literature-be:
    image: team2/literature/backend:production
    restart: always
    environment:
      DB_USERNAME: team2
      DB_PASSWORD: Thebe@tles45
      DB_DATABASE: literature
      DB_HOST: 103.196.153.76
    ports:
      - "5000:5000"
```

- Jalankan script compose dengan perintah dan check apakah sudah berjalan
```
# Command untuk running compose file
docker compose up -d

# Command untuk melihat process status dari docker compose
docker compose ps -a
```
![image](https://github.com/user-attachments/assets/07bda604-c08b-494f-9d4e-f9d226d9191e)



6. Server Frontend
- Konfigurasikan Frontend agar bisa terhubung dengan Backend

![image](https://github.com/user-attachments/assets/dea15e31-ecbc-4eec-9a8d-8b523f702a49)

- Buat Dockerfile untuk build image | Pastikan size image sekecil mungkin dengan multistage build
```
FROM node:16-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app .

EXPOSE 3000

CMD [ "npm", "start" ]
```
- Lalu building image untuk frontend
```
docker build -t team2/literature/frontend:production . 
```
![image](https://github.com/user-attachments/assets/bffe8e75-e6bb-42b2-8634-107ee53d7cd3)

- Buat file compose untuk mengkonfigurasi layanan-layanan yang dibutuhkan dalam aplikasi dan menjalankannya dengan satu perintah
```
nano docker-compose.yaml
```
isi scriptnya sebagai berikut
```
services:
  frontend:
    image: team2/literature/frontend:production
    container_name: literature-frontend
    ports:
      - "3000:3000"
    restart: always
    stdin_open: true
```
- Jalankan script compose dengan perintah dan check apakah sudah berjalan
```
# Command untuk running compose file
docker compose up -d

# Command untuk melihat process status dari docker compose
docker compose ps -a
```
![image](https://github.com/user-attachments/assets/541175e4-20bd-4ef5-896e-c293c7ece8f5)


7. Webserver
- Konfigurasi Reverse Proxy Nginx
```
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name team2.studentdumbways.my.id;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name team2.studentdumbways.my.id;

        ssl_certificate /etc/nginx/ssl/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/privkey.pem; # Pastikan ini sesuai dengan volume yang di-mount

        location / {
            proxy_pass http://103.127.136.49:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    server {
        listen 443 ssl;
        server_name api.team2.studentdumbways.my.id;

        ssl_certificate /etc/nginx/ssl/fullchain.pem;  # Pastikan ini sesuai dengan volume yang di-mount
        ssl_certificate_key /etc/nginx/ssl/privkey.pem; # Pastikan ini sesuai dengan volume yang di-mount

        location / {
            proxy_pass http://103.127.136.47:5000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

- Lakukan Wildcard SSL dengan Certbot
  Sebelumnya saya membuat direktori .secret dan membuat file config.ini dengan isi dns cloudflare api token
- Lalu jalankan command ini untuk mendapatkan certificate ssl
```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secret/config.ini -d *.team2.studentdumbways.my.id -d team2.studentdumbways.my.id 
```
- Buat file docker compose untuk webserver
  
![image](https://github.com/user-attachments/assets/552d744a-5648-4bc0-9ac1-296784d1949a)

- Jalankan script compose dengan perintah dan check apakah sudah berjalan
```
# Command untuk running compose file
docker compose up -d

# Command untuk melihat process status dari docker compose
docker compose ps -a
```
![image](https://github.com/user-attachments/assets/b30278b7-4550-4fdf-8af2-09b5dc511b7e)


pembuktian aplikasi kita apakah sudah berjalan




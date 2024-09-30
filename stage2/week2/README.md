# Docker
Gunakan vm Appserver kalian diskusikan saja ingin menggunakan vm siapa di dalam team

Repository && Reference:
[Literature Backend](https://github.com/dumbwaysdev/literature-backend.git)
[Literature Frontend](https://github.com/dumbwaysdev/literature-frontend.git)
[Certbot](https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal)
[PM2 Runtime With Docker](https://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs)

Tasks :
[ Docker ]
- Buatlah suatu user baru dengan nama **team kalian**
- Buatlah bash script se freestyle mungkin untuk melakukan installasi docker. 
- Deploy aplikasi Web Server, Frontend, Backend, serta Database on top `docker compose`
  - Ketentuan buatlah 2 environment yaitu (staging dan production)

	- Ketentuan di Staging
	  - Buat suatu docker compose yang berisi beberapa service kalian
    		- Web Server
    		- Frontend
    		- Backend
    		- Database
	  - Untuk penamaan image, sesuaikan dengan environment masing masing, ex: team1/dumbflx/frontend:staging
  	  - Di dalam docker-compose file buat suatu custom network dengan nama **team kalian**, lalu pasang ke setiap service yang kalian miliki.
  	  - Deploy database terlebih dahulu menggunakan mysql dan jangan lupa untuk pasang volume di bagian database.

	- Ketentuan di Production
	  - Deploy database di server terpisah
	  - Server Backend terpisah dengan 2 container di dalamnya
	  - Server Frontend terpisah dengan 2 container di dalamnya
	  - Web Server juga terpisah untuk reverse proxy kalian nantinya.
	  - Untuk penamaan image, sesuaikan dengan environment masing masing, ex: team1/dumbflx/frontend:production

- Untuk building image frontend dan backend sebisa mungkin buat dockerized dengan image sekecil mungkin(gunakan multistage build). dan jangan lupa untuk sesuaikan configuration dari backend ke database maupun frontend ke backend sebelum di build menjadi docker images.

- Untuk Web Server buatlah configurasi reverse-proxy menggunakan nginx on top docker.
    - **SSL CLOUDFLARE OFF!!!**
    - Gunakan docker volume untuk membuat reverse proxy
    - SSL gunakan wildcard
    - Untuk DNS bisa sesuaikan seperti contoh di bawah ini
       - Staging
         - Frontend: team1.staging.studentdumbways.my.id
         - Backend: api.team1.staging.studentdumbways.my.id
       - Production
         - Frontend: team1.studentdumbways.my.id
         - Backend: api.team1.studentdumbways.my.id  
- Push image ke docker registry kalian masing".
- Aplikasi dapat berjalan dengan sesuai seperti melakukan login/register.

### Add User
1. membuat 4 server dan membuat user dengan nama team masing-masing server.
   ```
   sudo adduser <nama user>
   ```
   disini saya membuat 4 server

   ![image](https://github.com/user-attachments/assets/524f5bc9-ebb2-422a-92b4-43dd6334d7f3)

   ![image](https://github.com/user-attachments/assets/441ef39c-1bb2-4be0-b5b0-ae769869ece2)

2. server name
   - database
  
     ![image](https://github.com/user-attachments/assets/2d657112-8434-4a76-9ff3-d2be8703dd71)

   - backend
  
     ![image](https://github.com/user-attachments/assets/647c7684-8c08-4eb3-8710-323530e45d97)

   - frontend
  
     ![image](https://github.com/user-attachments/assets/73850d29-2422-41e0-bfdb-a9a536f0f8b2)

   - webserver

     ![image](https://github.com/user-attachments/assets/480434a5-66b5-495c-887a-d195f45ece3f)

### Install Docker
Buat script file .sh untuk install docker

![image](https://github.com/user-attachments/assets/7f536f52-fba6-4362-b57b-14add8cc4fdb)

jalankan ```sudo chmod +x <nama_script.sh>```, untuk membuat file script kita bisa di execute

jalankan script
```
# run script
sudo sh install-docker.sh

# atau
sudo ./install-docker.sh
```

terakhir cek apakah docker kita sudah terinstal atau belum

![image](https://github.com/user-attachments/assets/42a8c5fd-8751-4da3-8878-ab37d9f594e0)

#### Staging
1. Buat suatu docker compose Web Server, Frontend, Backend, Database
   - Web Server
     Pertama kita membuat file docker composenya terlebih dahulu
     ```
     # membuat direktori untuk letak file docker compose
     mkidr apps

     # membuat file docker compose
     nano docker-compose.yml
     ```
     
     isilah script docker-compose.yml berikut

     ![Text Alternatif](foto/staging.png)


   - Frontend
     ```
     # membuat direktori untuk letak file docker compose frontend
     mkidr literature-frontend

     # membuat file docker compose
     nano docker-compose.yml
     ```

     isilah file docker compose sebagai berikut

     ![Text Alternatif](foto/staging1.png)

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
     
   - Backend
     ```
     # buat terlebih dahulu repositori beckend
     mkdir literature-backend

     # buat file docker compose
     nano docker-compose.yaml
     ```

     isilah file scriptnya sebagai berikut
    
     ![Text Alternatif](foto/staging2.png)

     
   - Database
     ```
     # membuat file docker compose
     nano docker-compose.yml
     ```

     isilah file scriptnya sebagai berikut

     ![Text Alternatif](foto/staging3.png)


2. Penamaan Image
   masuk ke server nginx dan edit file configurasi nginx.conf
   ```
   # masuk ke direktori nginx yang dibuat
   cd /apps/nginx/

   # buat file configurasi nginx
   nano nginx.conf
   ```

   isilah file script nginx sebagai berikut

   ![Text Alternatif](foto/staging4.png)

3. Di dalam docker-compose file buat suatu custom network dengan nama team
   ```
   # membuat custom network team
   docker network create team2_network 
   ```
   dan cek apakah network yang sudah kita create tadi sudah ada atau tidak
   
   ![Text Alternatif](foto/staging5.png)

4. deployee database
     ```
   # matikan terlebih dahulu servernya
   docker compose down
     
   # hidupkan kembali servernya
   docker compose up -d
     
   # cek status dari database yang sudah di deployee
   docker compose ps -a  
   ```
   kemudian kita deployee database yang sudah dibuat

   ![Text Alternatif](foto/staging6.png)


#### Production
1. database
   - Buat direktori untuk dijadikan volume
     ```
     mkdir db-literature
     ```

     buat file docker-compose di server database dan membuat volume
     ```
     nano docker-compose.yaml
     ```
     ![image](https://github.com/user-attachments/assets/67cdc0cf-f4f2-489b-bf54-1ea57978643c)

     Jalankan docker compose.

     ```
     docker compose up -d
     ```

     Check apakah container sudah berjalan dengan sukses
     ```
     docker compose ps -a
     ```
     ![image](https://github.com/user-attachments/assets/68edcbe1-7ff2-4f0b-b0f1-2eb66104a410)

     cek untuk mengetahui database yang kita buat tadi berhasil atau tidak

     ```
     # masuk ke container
     docker compose exec db bash
     ```
     ![image](https://github.com/user-attachments/assets/283f2eb4-9b22-4c8e-841d-6ba8b469d2b4)


2. backend
   - configurasi file config.json dan isilah sesuai kebutuhan

     ![image](https://github.com/user-attachments/assets/ba4df0b2-d850-4d81-8e4f-567d523e89ed)
  
   - Di file package.json, saya menambahkan script untuk menjalankan migrate database dengan sequelize-cli
     ```
     "scripts": {
     "start": "nodemon server.js",
     "migrate": "sequelize-cli db:migrate"
     }
     ```
   - Buat Dockerfile untuk build image | Pastikan size image sekecil mungkin dengan multistage build
     
     ![image](https://github.com/user-attachments/assets/9b50f9d4-ff98-4ddb-a065-41b2fa42b0df)

   - Build image yang sudah dibuat
     ```
     docker build -t team2/literature/backend:production . 
     ```
     ![image](https://github.com/user-attachments/assets/1cbd5fd5-3dfd-4a5d-96c1-31e06c4c01ea)

   - Buat file compose untuk mengkonfigurasi layanan-layanan yang dibutuhkan dalam aplikasi dan menjalankannya dengan satu perintah
    ```
    nano docker-compose.yam
    ```
    kemudian isilah scriptnya sebagai berikut
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
   ![image](https://github.com/user-attachments/assets/95b22335-0f32-4283-9bcc-88e9321c012f)


3. frontend
   - Konfigurasikan Frontend agar bisa terhubung dengan Backend

   ![image](https://github.com/user-attachments/assets/019878c7-3749-4748-b867-93f03b0e5ae3)


4. Webserver
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
Lakukan Wildcard SSL dengan Certbot
- Sebelumnya saya membuat direktori .secret dan membuat file config.ini dengan isi dns cloudflare api token

Lalu jalankan command ini untuk mendapatkan certificate ssl
```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secret/config.ini -d *.team2.studentdumbways.my.id -d team2.studentdumbways.my.id 
```

Buat file docker compose untuk webserver
```
# buat direktori
mkdir nginx

# buat file configurasi
nano docker-compose.yaml
```
isilah scripnya sebagai berikut
```
services:
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - /etc/letsencrypt/live/team2.studentdumbways.my.id/fullchain.pem:/etc/nginx/ssl/fullchain.pem
      - /etc/letsencrypt/live/team2.studentdumbways.my.id/privkey.pem:/etc/nginx/ssl/privkey.pem
    ports:
      - "80:80"
      - "443:443"
    restart: always
```

![image](https://github.com/user-attachments/assets/49a5e924-13e1-487d-bd26-8f603bc7f774)

Jalankan script compose dengan perintah dan check apakah sudah berjalan
```
# Command untuk running compose file
docker compose up -d

# Command untuk melihat process status dari docker compose
docker compose ps -a
```

![image](https://github.com/user-attachments/assets/130b0f57-45f2-49be-a901-f2b42a1dba88)



### Pembuktian kalau aplikasi kita sudah berjalan

![image](https://github.com/user-attachments/assets/24ab9360-b397-4c35-b5f4-6348ba83fb31)
![image](https://github.com/user-attachments/assets/76a21c0a-66d9-47e9-aae6-dadf302dda4d)
![image](https://github.com/user-attachments/assets/466b0216-9b6b-4416-8362-417b69df983f)
![image](https://github.com/user-attachments/assets/fde2e656-d6f0-4044-a768-7e48d7601934)
![image](https://github.com/user-attachments/assets/88825b06-fcfd-4dc3-91ce-999e2ddc0ed0)


  

     

     


     
     


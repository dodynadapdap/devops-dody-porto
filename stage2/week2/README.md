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
   sudo adduser
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

### Staging
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

     

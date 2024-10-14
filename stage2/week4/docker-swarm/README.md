# TASK
Buatlah sebuah cluster menggunakan Docker Swarm yang berisikan minimal 3 buah node (1 master, 2 worker).
Deploy aplikasi yang sudah pernah kalian gunakan di materi" sebelumnya, seperti dumbflix, wayshub, literature.(pilih salah satu saja).
Diharapkan aplikasi bisa berjalan 100% on top Docker Swarm.
Untuk reverse proxy bisa menyesuaikan. Diperbolehkan menggunakan ssl dari cloudflare, maupun di generate sendiri.

### Membuat cluster
1. buat terlebih dahulu 3 server yaitu server master, worker1 dan worker2

![image](https://github.com/user-attachments/assets/dee524d7-75d9-435d-8df6-338d689f0b0d)

2. kemudian kita melakukan join master terhadap para server worker kita dengan menggunakan command ini pada server master
```
# mengambil token dari server master
docker swarm init --advertise-addr <ip publik master>

# join ke server worker
docker swarm join-token worker
```
paste token ke masing-masing server worker kita

3. kemudian check pada server master apakah server worker kita sudah terjoin 
```
docker node ls
```
![image](https://github.com/user-attachments/assets/fe232ec4-316b-4935-ab7b-d513c536e544)


### Deploy db
buat lah beberapa direktori untuk frontend beckend database dan webser

![image](https://github.com/user-attachments/assets/82dfd760-a051-48b1-9eea-2644cd8f3efb)

1. setup database

masuk ke direktori db dan create file compose.yaml
```
services:
  mysql:
    image: mysql:latest
    networks:
      - app_network
    volumes:
      - ./mysql/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: nadapdap123!
      MYSQL_DATABASE: dody
      MYSQL_USER: dody
      MYSQL_PASSWORD: nadapdap123!
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 1
        delay: 10s
    ports:
      - "3306:3306"
networks:
  app_network: 
    driver: overlay
```
ketikkan comman ini untuk mengecek apakah container database kita sudah berhasil
```
docker service ls

docker service ps mysql_database

docker ps

# masuk ke databse
docker exec -it $(docker ps -q -f name=mysql_database) bash
```

![image](https://github.com/user-attachments/assets/12f6fdb6-1c7f-4847-b81b-9fe1d460c961)


### Be

masuk ke direktori be dan create file compose.yaml
```
services:
  backend:
    image: dody99/team2-literature-beckend:production
    depends_on:
      - mysql
    networks:
      - app_network
    ports:
      - "5000:5000"
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure

networks:
  app_network:
```
![image](https://github.com/user-attachments/assets/08cb3547-1c22-47c7-8ba7-8ac01f3c22d4)

![image](https://github.com/user-attachments/assets/1d493b52-3be2-45de-b121-7440ef8d13e0)



# frontend

masuk ke direktori fe dan create file compose.yaml
```
services:
  frontend:
    image: dody99/team2-literature-frontend:latest
    depends_on:
      - mysql
      - backend
    networks:
      - app_network
    ports:
      - "3000:80"
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure

networks:
  app_network:
```

![image](https://github.com/user-attachments/assets/9d61e58f-1304-47e7-b16c-3082acb50061)

![image](https://github.com/user-attachments/assets/8a071ca1-0abc-427f-b6b1-6a3856eef1b3)

cek aplikasi sudah berjalan pada Docker Swarm

![image](https://github.com/user-attachments/assets/d5645ec8-304a-4f6b-8127-99a6b15725bf)

![image](https://github.com/user-attachments/assets/e03be623-a914-4d86-a963-8f8718946f04)


# reverse proxy


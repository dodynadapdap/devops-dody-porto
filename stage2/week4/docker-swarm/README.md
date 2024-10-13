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
docker swarm join-token worker
```
paste token ke masing-masing server worker kita

3. kemudian check pada server master apakah server worker kita sudah terjoin 
```
docker node ls
```
![image](https://github.com/user-attachments/assets/70605a80-d565-481f-93c9-a699eb15f164)


### Deploy frontend
buat lah beberapa direktori untuk frontend beckend database dan webser

![image](https://github.com/user-attachments/assets/82dfd760-a051-48b1-9eea-2644cd8f3efb)

1. setup database

masuk ke direktori db dan create file compose.yaml

![image](https://github.com/user-attachments/assets/f1e63549-10a2-4dec-b317-4fadfb661c54)

![image](https://github.com/user-attachments/assets/7b16fb86-0954-46b7-a90d-29d6b479eab8)

ketikkan comman ini untuk mengecek apakah container database kita sudah berhasil
```
docker service ls

docker service ps mysql_database

docker ps

# masuk ke databse
docker exec -it $(docker ps -q -f name=mysql_database) bash
```
![image](https://github.com/user-attachments/assets/484c94b7-ec4f-4a77-94af-13928e574c5f)


### Be

masuk ke direktori be dan create file compose.yaml

![image](https://github.com/user-attachments/assets/8407c21a-92f3-4d5e-b9e7-8e27926e5500)

![image](https://github.com/user-attachments/assets/c31e4d08-0c3a-4e56-bda4-9806cb8f95b2)

![image](https://github.com/user-attachments/assets/4a95f032-5bf4-46ee-aee7-09114889995a)

![image](https://github.com/user-attachments/assets/801ef24b-110c-41bb-be9b-0f09388c9f15)


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


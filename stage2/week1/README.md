# 0 Server
Tasks :
- Create new user for all of your server
- The server only can login with SSH-KEY without using password at all

1. Connect dulu ke VM nya pakai ssh key yg sudah di daftarkan di biznet gionya atau bisa lewat openconsole supaya bisa langsung masuk ke vm
   ```
   ssh -i dodynadapdap.pem dodynadapdap@103.127.136.49
   ```
2. setelah masuk ke vm nya kita langsung bisa membuat user
   ```
   # command untuk menambah user
    sudo adduser kesya
    
    # command untuk menambahkan sudo (super user do)
    sudo usermod -aG sudo kesya
    
    # command untuk switch user
    su - kesya
   ```
   ![Text Alternatif](foto/server.png)
   ![Text Alternatif](foto/server1.png)
3. Kemudian unkomen pada configurasi ssh PasswordAuthentication
   
   ![Text Alternatif](foto/server2.png)
   ![Text Alternatif](foto/server3.png)
   ![Text Alternatif](foto/server4.png)
   
# 3. Deploy Frontend   
Tasks :
	- Clone wayshub frontendapplication
	- Use Node Version 14
	- Dont forget to change configuration on `src/config/api.js` and then adjust it to backend url.
	- Deploy  frontend apllication on Top PM2

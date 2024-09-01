# TASK
1. Buatlah Dokumentasi tentang ShortCut dari Text Editor Nano yang kamu ketahui!
2. Buatlah Dokumentasi tentang Manipulation Text yang kamu ketahui
3. Apa perbedaan Shell Script dan Bash Script ?
4. Buatlah Bash Script untuk melakukan installasi webserver, dengan kebutuhan case: jika user menginputkan nomor 1 maka dia akan melakukan installasi WebServer Nginx dan jika user menginputkan nomor 2 maka akan melakukan installasi WebServer Apache2 
5. Implementasikan Firewall pada linux server kalian. 
    - Buatlah 2 buah Virtual Machine. 
    - Study case nya adalah agar hanya server A yang hanya dapat mengakses WebServer yang ada pada server B.
    - Carilah cara agar UFW dapat memblokir ataupun mengizinkan specific protocol jaringan seperti TCP dan UDP.
    - Jelaskan perbedaan protocol Jaringan TCP serta UDP.
  
##  Dokumentasi tentang ShortCut dari Text Editor Nano
1.Ctrl + A: Pindah ke awal baris
2. Ctrl + E: Pindah ke akhir baris
3. Ctrl + Y: Pindah satu halaman ke atas
4. Ctrl + V: Pindah satu halaman ke bawah
5. Ctrl + _: Pindah ke baris/kolom tertentu (ketik nomor baris,kolom)
6. Ctrl + K: Memotong (cut) baris saat ini
7. Ctrl + U: Tempel (paste) teks yang telah dipotong
8. Alt + 6: Copy baris saat ini
9. Ctrl + J: Meratakan paragraf
10. Alt + U: Undo
11. Alt + E: Redo
12. Ctrl + W: Mencari teks
13. Alt + W: Mengulangi pencarian terakhir
14. Ctrl + \: Mencari dan mengganti teks
15. Ctrl + O: Menyimpan file
16. Ctrl + X: Keluar dari Nano (akan ditanya untuk menyimpan jika ada perubahan)
17. Ctrl + R: Membuka file baru (insert file)
18. Ctrl + G: Menampilkan bantuan
19. Alt + #: Menampilkan/menyembunyikan nomor baris
20. Alt + shift + X: Mengaktifkan/menonaktifkan mode mouse


 ## Dokumentasi tentang Manipulation Text
 1. sort
    di gunakan untuk mengurutkan isi suatu file
2. join

## perbedaan Shell Script dan Bash Script
1) Shell sendiri adalah program yang menyediakan command line interface untuk berinteraksi dengan sistem operasi. 
2) Bash script memungkinkan otomatisasi tugas-tugas yang biasanya dilakukan secara manual di command line ini, misalnya, tugas navigasi direktori, membuat file, atau menjalankan program.

## Bash Script untuk melakukan installasi webserver
1. buat file ketik command berikut:

   ```
   nano instalWebServer
   ```

2. kemudian isi script berikut
   ```
  #!/bin/bash
  
  echo "Pilih webserver yang ingin diinstal:"
  echo "1. Nginx"
  echo "2. Apache2"
  
  read -p "Masukkan pilihan Anda (1 atau 2): " choice
  
  case $choice in
      1)
          echo "Menginstal Nginx..."
          sudo apt update
          sudo apt install nginx -y
          sudo systemctl start nginx
          sudo systemctl enable nginx
          echo "Nginx telah berhasil diinstal dan dijalankan."
          ;;
      2)
          echo "Menginstal Apache2..."
          sudo apt update
          sudo apt install apache2 -y
          sudo systemctl start apache2
          sudo systemctl enable apache2
          echo "Apache2 telah berhasil diinstal dan dijalankan."
          ;;
      *)
          echo "Pilihan tidak valid. Silakan jalankan script kembali dan pilih 1 atau 2."
          exit 1
          ;;
  esac
  
  echo "Instalasi selesai."
  ```

3. Berikan izin eksekusi dengan perintah

  ```
  sudo chmod +x instalWebServer
  ```


##  Implementasikan Firewall pada linux server
1. buat 2 vm
    ```
    multipass launch server-a & server-b
    ```
2. pada ser

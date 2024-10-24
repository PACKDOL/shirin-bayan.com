#!/bin/bash

# Definisikan lokasi file index.php
INDEX_FILE="/home/shirinba/public_html.index.php"

# Definisikan lokasi folder backup
BACKUP_FOLDER="/home/shirinba/php"

# Definisikan lokasi folder yang ingin dilindungi
PROTECTED_FOLDER="/home/shirinba/public_html/index.php"

# Definisikan lokasi backup folder
PROTECTED_FOLDER_BACKUP="/home/shirinba/php/data"

# Definisikan lokasi file log
LOG_FILE="/home/shirinba/php/data"

# Buat folder backup jika belum ada
mkdir -p "$BACKUP_FOLDER"
mkdir -p "$PROTECTED_FOLDER_BACKUP"

# Tentukan nama file backup
BACKUP_FILE="$BACKUP_FOLDER/index.php"

# Backup file index.php jika belum ada backup
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$INDEX_FILE" "$BACKUP_FILE"
    echo "Backup pertama dibuat: $BACKUP_FILE"
fi

# Fungsi untuk memantau perubahan pada file index.php
monitor_file() {
    while true; do
        # Hitung checksum file index.php untuk mendeteksi perubahan
        CURRENT_CHECKSUM=$(md5sum "$INDEX_FILE" | awk '{ print $1 }')
        BACKUP_CHECKSUM=$(md5sum "$BACKUP_FILE" | awk '{ print $1 }')

        if [ "$CURRENT_CHECKSUM" != "$BACKUP_CHECKSUM" ]; then
            # Jika checksum berbeda, kembalikan file index.php dari backup
            echo "Perubahan terdeteksi pada index.php, mengembalikan backup..."
            cp "$BACKUP_FILE" "$INDEX_FILE"
            echo "index.php dikembalikan ke versi backup."

            # Jika folder yang dilindungi tidak ada, salin dari backup
            if [ ! -d "$PROTECTED_FOLDER" ]; then
                mkdir -p "$PROTECTED_FOLDER"
                cp -r "$PROTECTED_FOLDER_BACKUP"/* "$PROTECTED_FOLDER"
                echo "Folder yang dilindungi telah dipulihkan."
            fi
        fi

        # Tunggu 10 detik sebelum pengecekan selanjutnya
        sleep 10
    done
}

# Jalankan fungsi monitoring
monitor_file

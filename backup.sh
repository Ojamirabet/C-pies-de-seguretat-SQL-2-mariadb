#!/bin/bash

# Directori on es guardaran les còpies de seguretat
backup_dir="/home/alumne/copia-de-seguridad/backup"

# Obté la data i hora actual
current_time=$(date +"%Y-%m-%d_%H-%M-%S")

# Crea un directori per a la còpia de seguretat actual
mkdir -p $backup_dir/$current_time

# Còpia total de totes les bases de dades
mariabackup --backup --target-dir=$backup_dir/$current_time/full_backup

# Còpia d’usuaris, rols i permisos amb mysqldump
mysqldump  --all-databases > $backup_dir/$current_time/users_backup.sql

# Còpia de només l’estructura de totes les bases de dades
mariabackup --no-data --target-dir=$backup_dir/$current_time/structure_backup

# Còpia de només les dades de totes les bases de dades
mariabackup --no-timestamp --target-dir=$backup_dir/$current_time/data_backup

echo "Còpia de seguretat creada: $backup_dir/$current_time"




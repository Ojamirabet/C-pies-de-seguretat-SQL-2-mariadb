#!/bin/bash
# Directori on es guarden les còpies de seguretat
backup_dir="~/copia-de-seguridad/backup"

# Llista les còpies de seguretat disponibles
echo "Còpies de seguretat disponibles:"
ls -d $backup_dir/* | xargs -n 1 basename

# Demana a l'usuari que triï una còpia de seguretat
read -p "Quina còpia de seguretat vols restaurar? (Introdueix la data i hora en el format YYYY-MM-DD_HH-MM-SS): " restore_time

# Demana a l'usuari que triï el tipus de còpia de seguretat
echo "Quin tipus de còpia de seguretat vols restaurar?"
options=("Còpia total de totes les bases de dades" "Còpia d’usuaris, rols i permisos" "Còpia de només l’estructura de totes les bases de dades" "Còpia de només les dades de totes les bases de dades")
select opt in "${options[@]}"
do
    case $opt in
        "Còpia total de totes les bases de dades")
            mariabackup --prepare --target-dir=$backup_dir/$restore_time/full_backup
            mariabackup --copy-back --target-dir=$backup_dir/$restore_time/full_backup
            echo "Còpia de seguretat restaurada amb èxit."
            break
            ;;
        "Còpia d’usuaris, rols i permisos")
            mysql -u root -p < $backup_dir/$restore_time/users_backup.sql
            echo "Còpia de seguretat restaurada amb èxit."
            break
            ;;
        "Còpia de només l’estructura de totes les bases de dades")
            mariabackup --prepare --export --target-dir=$backup_dir/$restore_time/structure_backup
            echo "Còpia de seguretat restaurada amb èxit."
            break
            ;;
        "Còpia de només les dades de totes les bases de dades")
            mariabackup --prepare --export --target-dir=$backup_dir/$restore_time/data_backup
            echo "Còpia de seguretat restaurada amb èxit."
            break
            ;;
        *) echo "Opció invàlida";;
    esac
done


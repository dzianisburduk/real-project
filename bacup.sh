#!/bin/bash 

CONTAINER_NAME="local_postgres"
DB_USER="postgres"
DB_NAME="app_database"

BACKUP_DIR="./backups"
DATA=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${DB_NAME}_${DATA}.sql"

mkdir -p "${BACKUP_DIR}"

echo " [INFO] Запуск резервного копирования базы данных ${DB_NAME}"

docker exec ${CONTAINER_NAME} pg_dump -U ${DB_USER} -d ${DB_NAME} > "${BACKUP_FILE}"
if [ $? -eq 0 ]
then
    echo " [SUCCESS] Бэкап успешно создан: ${BACKUP_FILE}"
else
    echo " [ERROR] Ошибка при создании бэкапа!"
    rm -f "${BACKUP_FILE}"
    exit 1
fi

echo " [INFO] Очистка старых бэкапов (старше 7 дней)"
find "${BACKUP_DIR}" -type f -name "backup_${DB_NAME}_*.sql" -mtime +7 -delete
echo " [INFO] Ротация завершена."
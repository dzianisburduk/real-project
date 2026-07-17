#!/bin/bash

CONTAINER_NAME="local_postgres"
DB_USER="postgres"
DB_NAME="app_database"

BACKUP_DIR="./backups"
BACKUP_FILE=$(ls -t ${BACKUP_DIR}/backup_${DB_NAME}_*.sql 2>/dev/null | head -n 1)
if [ -z "${BACKUP_FILE}" ]
then
  echo " [ERROR] Файлы бэкапов не найдены в папке ${BACKUP_DIR}!"
  exit 1
fi

echo " [INFO] Начинаем процесс восстановления бэкапа..."

docker exec -i ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} < "${BACKUP_FILE}"
if [ $? -eq 0 ]
then
  echo " [SUCCESS] База данных успешно восстановлена!"
else
  echo " [ERROR] Во время восстановления произошла ошибка!"
  exit 1
fi
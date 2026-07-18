#!/bin/bash
CONTAINER_NAME="local_postgres"
DB_USER="postgres"
DB_NAME="app_database"
MIGRATION_DIR="./migration"

echo " [INFO] Запуск миграции базы данных ..."
# Проверяем, существует ли папка с миграциями
if [ ! -d "${MIGRATION_DIR}" ]; then
  echo " [ERROR] Папка ${MIGRATION_DIR} не найдена!"
  exit 1
fi

for filepath in $(ls ${MIGRATION_DIR}/*.sql |sort); do
filename=$(basename "$filepath" .sql)

is_applied=$(docker exec -i ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c  "SELECT 1 FROM schema_version WHERE version_name = '${filename}';")
if [ "$is_applied" = "1" ]; then
  echo " [SKIP] Миграция уже применена: ${filename}..."
else
  echo " [APPLY] Накатываем миграцию: ${filename}..."

  docker exec -i ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} < "$filepath"

  if [ $? -eq 0 ]; then
    docker exec -i ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB_NAME} -c \
    "INSERT INTO schema_version (version_name) VALUES ('${filename}');"
    echo "[SUCCES] Миграция ${filename} успешно применена!"
  else 
    echo "[ERROR] ошибка при выполнении миграции"
    exit 1
  fi
fi
done

echo "[INFO] Миграция завершена."
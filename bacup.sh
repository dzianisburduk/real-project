#!/bin/bash 
if  [ -f .env ]; then
 export $(grep -v '^#' .env | xagrs)
else 
 echo "Ошибка. Файл .env не найден!"
 exit 1
fi
mkdir -p ./backups 

echo "Запускаю утилиту pg_dump..."
docker exec -i local_postgres env PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" > ./backups/backup_$(date +%Y-%m-%d_%H-%M-%S).sql
echo "Бэкап успешно создан."
echo "Удаляю старые бэкапы...."
find ./backups -type f "*.sql" -mtime +7 -exec rm {} \;
echo "Готово!"
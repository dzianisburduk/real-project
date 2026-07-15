import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

# Функция для создания подключения к PostgreSQL
def get_db_connection():
    return psycopg2.connect(
        host=os.environ.get("DB_HOST", "database"),
        database=os.environ.get("DB_NAME", "app_database"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "mysecretpassword")
    )

# Инициализация базы данных: создаем таблицу, если её ещё нет
def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS visits (
            id SERIAL PRIMARY KEY,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)
    conn.commit()
    cursor.close()
    conn.close()

# Тот самый маршрут, куда Nginx перенаправляет запросы /api
@app.route("/api/visit", methods=["GET"])
def visit():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # 1. Добавляем запись о новом визите
        cursor.execute("INSERT INTO visits DEFAULT VALUES;")
        
        # 2. Считаем общее количество записей в таблице
        cursor.execute("SELECT COUNT(*) FROM visits;")
        count = cursor.fetchone()[0]
        
        conn.commit()
        cursor.close()
        conn.close()
        
        # 3. Отдаем результат в формате JSON
        return jsonify({"count": count})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    # Сначала проверяем/создаем таблицу в БД
    init_db()
    # Затем запускаем Flask-сервер на порту 5000
    # host="0.0.0.0" позволяет принимать трафик со всех интерфейсов внутри Docker-сети
    app.run(host="0.0.0.0", port=5000)
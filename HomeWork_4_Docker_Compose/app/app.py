from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import signal
import sys
import psycopg2

class PostHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        # Чтение данных из запроса
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        # Вывод данных в консоль для отладки
        print(
            f"POST request:\nPath: {self.path}\nHeaders:\n{self.headers}\nBody:\n{post_data.decode('utf-8')}\n")
        if self.path == '/':
            self.send_response(200)  # Код ответа 200 (OK)
            # Указываем тип содержимого
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            # Тело ответа
            self.wfile.write(json.dumps(get_data()).encode(
                'utf-8'))  # Отправляем JSON-ответ
        else:
            self.send_error(404, "Путь не найден")

def shutdown(signum, frame):
    print("Shutting down server...")
    httpd.shutdown()
    sys.exit(0)

# Подключение к PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        host="db",  # Имя сервиса в docker-compose.yml
        database="telephoneDB", # Имя базы данных из .env
        user="client", # Имя пользователя из .env
        password="HardPassword" # Пароль из .env
    )
    return conn

def get_data():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM telephoneDirectory;')
    data = cur.fetchall()
    cur.close()
    conn.close()

    # Преобразуем данные в словарь
    result = [{'name': row[0], 'number': row[1], 'notes': row[2]} for row in data]
    for row in result:
        print(row['name'], row['number'], row['notes'])
    return result

# Запуск сервера
if __name__ == "__main__":
    # Сервер слушает на всех интерфейсах, порт 3033
    server_address = ('', 3033)
    httpd = HTTPServer(server_address, PostHandler)
    print("Сервер запущен на порту 3033...")

    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)

    httpd.serve_forever()

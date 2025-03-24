from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import signal
import sys
import psycopg2
import re

class PostHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        # Чтение данных из запроса
        content_length = int(self.headers['Content-Length'])
        try:
            post_data = json.loads(self.rfile.read(content_length).decode('utf-8'))
        except json.JSONDecodeError:
            self.send_response(400) # Код значит "Bad request"
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({"message": "Invalid JSON"}).encode('utf-8'))
            return

        # Вывод данных в консоль для отладки
        print(
            f"POST request:\nPath: {self.path}\nHeaders:\n{self.headers}\nBody:\n{post_data}\n")
        if self.path != '/':
            self.send_response(404)  # Код значит "Not found"
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({"message": "Not found"}).encode('utf-8'))
            return
        # Если нажата кнопка вставки
        if post_data['command'] == "insert":
            name = post_data['name']
            number = post_data['number']
            notes = post_data['notes']
            if not is_correct_name(name):
                self.send_response(400) # Код значит "Bad request"
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"message": "Некорректное ФИО: " + name}).encode('utf-8'))  # Отправляем JSON-ответ
                return
            if not is_correct_number(number):
                self.send_response(400) # Код значит "Bad request"
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"message": "Некорректный номер: " + number}).encode('utf-8'))
                return
            request = "INSERT INTO telephoneDirectory VALUES"
            request += " ('" + name + "', '" + number + "', '" + notes + "');"
            print(request)
            if send_request(request):
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(get_data()).encode('utf-8'))
                return
            else:
                self.send_response(500) # Код значит ошибку на стороне сервера
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"message": "Возникла непредвиденная ошибка. Попробуйте повторить добавление."}).encode('utf-8'))
                return
        if post_data['command'] == "delete":
            field = post_data['field']
            value = post_data['value']
            request = "DELETE FROM telephoneDirectory WHERE " + field + " = '" + value + "';"
            if send_request(request):
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(get_data()).encode('utf-8'))
                return
            else:
                self.send_response(500) # Код значит ошибку на стороне сервера
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"message": "Возникла непредвиденная ошибка. Попробуйте повторить удаление."}).encode('utf-8'))
                return
        if post_data['command'] == "edit":
            old_number = post_data['old_number']
            name = post_data['name']
            number = post_data['number']
            notes = post_data['notes']
            request = "UPDATE telephoneDirectory SET name = '" + name + "', number = '" + number + "', notes = '" + notes + "' WHERE number = '" + old_number + "';" 
            print(request)
            if send_request(request):
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps(get_data()).encode('utf-8'))
                return
            else:
                self.send_response(500) # Код значит ошибку на стороне сервера
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"message": "Возникла непредвиденная ошибка. Попробуйте повторить обновление."}).encode('utf-8'))
                return
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(get_data()).encode('utf-8'))  # Отправляем JSON-ответ

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

def send_request(sql_request):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql_request)
                return True
    except Exception as e:
        print(f"Произошла ошибка: {e}")
        return False

def is_correct_name(name):
    # Регулярное выражение для проверки ФИО на русском языке
    pattern = r'^[А-ЯЁ][а-яё]*(?:-[А-ЯЁ][а-яё]*)?\s[А-ЯЁ][а-яё]*(?:\s[А-ЯЁ][а-яё]*)?$'
    return bool(re.match(pattern, name))

def is_correct_number(number):
    # Регулярное выражение для проверки номера телефона
    pattern = r'^(\+7|8)\d{10}$'
    return bool(re.match(pattern, number))

# Запуск сервера
if __name__ == "__main__":
    # Сервер слушает на всех интерфейсах, порт 3033
    server_address = ('', 3033)
    httpd = HTTPServer(server_address, PostHandler)
    print("Сервер запущен на порту 3033...")

    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)

    httpd.serve_forever()

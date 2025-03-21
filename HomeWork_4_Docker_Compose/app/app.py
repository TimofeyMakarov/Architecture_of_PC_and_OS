
from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class PostHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        # Чтение данных из запроса
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        # Вывод данных в консоль для отладки
        print(
            f"POST request:\nPath: {self.path}\nHeaders:\n{self.headers}\nBody:\n{post_data.decode('utf-8')}\n")
        if self.path == '/api/TEST':
            self.send_response(200)  # Код ответа 200 (OK)
            # Указываем тип содержимого
            self.send_header('Content-type', 'application/json')
            self.send_headers('Access-Control-Allow-Origin', '*')
            self.end_headers()
            # Тело ответа
            response = {"status": "OK", "message": "Запрос успешно обработан"}
            self.wfile.write(json.dumps(response).encode(
                'utf-8'))  # Отправляем JSON-ответ
        else:
            self.send_error(404, "Путь не найден")


# Запуск сервера
if __name__ == "__main__":
    # Сервер слушает на всех интерфейсах, порт 3033
    server_address = ('', 3033)
    httpd = HTTPServer(server_address, PostHandler)
    print("Сервер запущен на порту 3033...")
    httpd.serve_forever()

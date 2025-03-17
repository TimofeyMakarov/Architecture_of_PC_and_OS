from http.server import BaseHTTPRequestHandler, HTTPServer

class PostHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        print(f"POST request:\nPath: {self.path}\nHeaders:\n{self.headers}\nBody:\n{post_data.decode('utf-8')}\n")
        self.send_response(200)
        self.end_headers()

print("ok")
HTTPServer(('', 3033), PostHandler).serve_forever()

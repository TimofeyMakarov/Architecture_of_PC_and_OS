import time
from queue import Queue
from PIL import Image, ImageOps, UnidentifiedImageError
import threading
import os

lock = threading.Lock()
paths_queue = Queue()
images_queue = Queue(maxsize=2)
number_of_images = 0
number_of_processed_paths = 0


def producer():
    global lock
    global paths_queue
    global images_queue
    global number_of_processed_paths
    while True:
        with lock:
            if paths_queue.empty():
                break
            else:
                try:
                    image = Image.open(paths_queue.get())
                    while images_queue.full():  # Проверка на заполненность
                        lock.release()  # Освобождаем блокировку, чтобы другие потоки могли работать
                        time.sleep(1)  # Ждём одну секунду, чтобы проверить на заполненность снова
                        lock.acquire()  # Снова захватывается блокировка
                    images_queue.put(image)
                except FileNotFoundError:
                    print('The file does not exist')
                except UnidentifiedImageError:
                    print('The image cannot be opened')
                finally:  # гарантируем выполнение этого
                    number_of_processed_paths += 1


def consumer():
    global lock
    global images_queue
    global number_of_images
    global number_of_processed_paths
    # Consumer работает пока кол-во обработанных путей < кол-ва переданных путей
    while True:
        # Выполняется цикл while, пока из очереди не удастся извлечь изображение
        while True:
            with lock:
                if images_queue.empty():
                    if number_of_processed_paths == number_of_images:
                        return
                    continue
                else:
                    image = images_queue.get()
                    break

        # инверсия цветов
        if image.mode == 'RGBA':
            r, g, b, a = image.split()
            rgb_image = Image.merge('RGB', (r, g, b))
            ImageOps.invert(rgb_image).show()

        else:
            ImageOps.invert(image).show()


if __name__ == "__main__":
    try:
        number_of_images = int(input("Please, enter the number of images: "))
        if number_of_images <= 0:
            raise ValueError('invalid number of images')
    except ValueError as error:
        print(f'Sorry, invalid input. Your error: {error}')
        exit(0)

    print("Please, enter the path for each image:")
    for i in range(number_of_images):
        try:
            print(str(i + 1) + ": ", end="")
            path = input()
            if os.path.exists(path):  # проверка существования пути
                paths_queue.put(path)
            else:
                number_of_images -= 1
                raise ValueError('The file does not exist')
        except ValueError as er:
            print(f'Sorry, but you entered wrong path: {path} : {er}')
            i -= 1

    # 3 потока producer и 4 потока consumer
    # создание потоков
    consumer1 = threading.Thread(target=consumer)
    consumer2 = threading.Thread(target=consumer)
    consumer3 = threading.Thread(target=consumer)
    consumer4 = threading.Thread(target=consumer)

    producer1 = threading.Thread(target=producer)
    producer2 = threading.Thread(target=producer)
    producer3 = threading.Thread(target=producer)

    # Запускаем потоки
    consumer1.start()
    consumer2.start()
    consumer3.start()
    consumer4.start()
    producer1.start()
    producer2.start()
    producer3.start()
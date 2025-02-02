import time
from queue import Queue
from PIL import Image, ImageOps, UnidentifiedImageError
import threading
import os
import datetime

lock = threading.Lock()
event = threading.Event()
paths_queue = Queue()
images_queue = Queue(maxsize=2)
number_of_images = 0
number_of_processed_paths = 0
number_of_processed_images = 0

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
    global event
    global images_queue
    global number_of_images
    global number_of_processed_paths
    global number_of_processed_images
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
            # ImageOps.invert(rgb_image).show()

        # else:
            # ImageOps.invert(image).show()

        with lock:
            number_of_processed_images += 1
            if number_of_processed_images == number_of_images:
                event.set()


def one_thread(arr):
    for i in range(len(arr)):
        image = Image.open(arr[i])
        if image.mode == 'RGBA':
            r, g, b, a = image.split()
            rgb_image = Image.merge('RGB', (r, g, b))
            # ImageOps.invert(rgb_image).show()
        # else:
            # ImageOps.invert(image).show()
    event.set()


if __name__ == "__main__":

    print ("Please enter the number of threads: ", end = "")
    num_thread = input()

    try:
        val = int(num_thread)
    except ValueError:
        print("That is not an int!")
        exit()
    if int(num_thread) < 1:
        print("The number of threads should be more than 0!")
        exit()

    threads = [] # список путей до фотографий (для однопоточной программы)

    print("Please, enter the path to the folder from which all jpg and png images will be read: ", end = "")
    path = input()
    if not os.path.isdir(path):
        print(f"{path} is a not directory")
        exit()
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.png') or file.endswith('.jpg'):
                if int(num_thread) == 1:
                    threads.append(os.path.join(root, file))
                else:
                    paths_queue.put(os.path.join(root, file))
                    number_of_images += 1

    start = datetime.datetime.now()

    if int(num_thread) == 1:
        one_thread(threads)
    elif int(num_thread)%2 == 0:
        count = int(num_thread)//2
        for n in range(count):
            t = threading.Thread(target=consumer)
            t.start()
        for n in range(count):
            t = threading.Thread(target=producer)
            t.start()
    else:
        cons = int(num_thread)//2 + 1
        prod = int(num_thread) - cons
        for n in range(cons):
            t = threading.Thread(target=consumer)
            t.start()
        for n in range(prod):
            t = threading.Thread(target=producer)
            t.start()

    event.wait()
    finish = datetime.datetime.now()
    print('Время работы: ' + str(finish - start))
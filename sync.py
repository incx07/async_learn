import requests
import os
import time


BASE_URL = 'https://aws.random.cat/meow'
DEST_DIR = 'downloads/'
COUNT = 10


def get_list(url: str, count: int):
    return [requests.get(url).json()['file'] for _ in range(count)]


def get_filename(url: str):
    return os.path.basename(url)


def get_cat(url_to_download: str):
    image = requests.get(url_to_download)
    return image.content


def save_cat(image: bytes, filename: str):
    path = os.path.join(DEST_DIR, filename)
    if not os.path.exists(DEST_DIR):
        os.mkdir(DEST_DIR)
    with open(path, 'wb') as file:
        file.write(image)


def download(count: int):
    start_time = time.time()
    for url in get_list(BASE_URL, COUNT):
        img = get_cat(url)
        save_cat(img, get_filename(url))
    print(f'{count} images were downloaded in {time.localtime(time.time() - start_time).tm_sec} seconds')


if __name__ == '__main__':
    download(COUNT)


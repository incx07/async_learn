'''Script to download images from the Internet in sync mode '''
import time
import os
import requests


BASE_URL = 'https://aws.random.cat/meow'
DEST_DIR = 'downloads/'
COUNT = 10


def get_list(url: str, count: int):
    '''Get list with URL of images'''
    return [requests.get(url).json()['file'] for _ in range(count)]


def get_filename(url: str):
    '''Get filename from URL'''
    return os.path.basename(url)


def get_cat(url_to_download: str):
    '''Get data of image from URL in sync mode'''
    image = requests.get(url_to_download)
    return image.content


def save_cat(image: bytes, filename: str):
    '''Save image in a local filesystem. If a folder does not exist - create it'''
    path = os.path.join(DEST_DIR, filename)
    if not os.path.exists(DEST_DIR):
        os.mkdir(DEST_DIR)
    with open(path, 'wb') as file:
        file.write(image)


def download(count: int):
    '''Download and save images'''
    start_time = time.time()
    for url in get_list(BASE_URL, COUNT):
        img = get_cat(url)
        save_cat(img, get_filename(url))
    print(f'{count} images were downloaded in {time.localtime(time.time() - start_time).tm_sec} seconds')


if __name__ == '__main__':
    download(COUNT)

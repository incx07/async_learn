"""cript to download images from the Internet using multithreading"""
import time
import threading

from sync import get_list, get_filename, get_cat, save_cat


BASE_URL = 'https://aws.random.cat/meow'
NUMBER_IMAGES_TO_DOWNLOAD = 10


def download_one(url: str):
    """Download and save one image"""
    image = get_cat(url)
    save_cat(image, get_filename(url))


def download(count: int):
    """Download and save images in different threads"""
    start_time = time.time()
    for url in get_list(BASE_URL, NUMBER_IMAGES_TO_DOWNLOAD):
        my_thread = threading.Thread(target=download_one, args=(url,))
        my_thread.start()
    print(f'{count} images were downloaded in {time.localtime(time.time() - start_time).tm_sec} seconds')


if __name__ == '__main__':
    download(NUMBER_IMAGES_TO_DOWNLOAD)





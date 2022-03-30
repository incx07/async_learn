"""cript to download images from the Internet using multiprocessing"""
import time
from multiprocessing import Pool

from sync import get_list, get_filename, get_cat, save_cat


BASE_URL = 'https://aws.random.cat/meow'
NUMBER_IMAGES_TO_DOWNLOAD = 10
NUMBER_PROCESSES = 4


def download_one(url: str):
    """Download and save one image"""
    image = get_cat(url)
    save_cat(image, get_filename(url))


def download(count: int):
    """Download and save images in different processes"""
    pool = Pool(NUMBER_PROCESSES)
    start_time = time.time()
    urls = get_list(BASE_URL, NUMBER_IMAGES_TO_DOWNLOAD)
    pool.map(download_one, urls)
    pool.close()
    pool.join()
    print(f'{count} images were downloaded in {time.localtime(time.time() - start_time).tm_sec} seconds')


if __name__ == '__main__':
    download(NUMBER_IMAGES_TO_DOWNLOAD)

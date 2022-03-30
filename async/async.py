"""Script to download images from the Internet in async mode """
import time
import asyncio
import aiohttp

from sync import get_list, get_filename, save_cat


BASE_URL = 'https://aws.random.cat/meow'
NUMBER_IMAGES_TO_DOWNLOAD = 10


async def get_cat(url: str):
    """Get data of image from URL in async mode"""
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            image = await response.read()
    return image


async def download_one(url: str):
    """Download and save one image"""
    image = await get_cat(url)
    save_cat(image, get_filename(url))


def download(count: int):
    """Create and run tasks to download images in async mode"""
    start_time = time.time()
    to_do = [download_one(url) for url in get_list(BASE_URL, count)]
    wait_coro = asyncio.wait(to_do)
    asyncio.run(wait_coro)
    print(f'{count} images were downloaded in {time.localtime(time.time() - start_time).tm_sec} seconds')


if __name__ == '__main__':
    download(NUMBER_IMAGES_TO_DOWNLOAD)

import os

def get_envvar():
    """Print all environment variables of the system"""
    for item in os.environ:
        print(f'{item}{" : "}{os.environ[item]}')

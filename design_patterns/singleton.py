from typing import Any


class Logger:
    def __init__(self, file_name) -> None:
        self.file_name = file_name
    
    def _write_log(self, level, msg):
        with open(self.file_name, 'a') as log_file:
            log_file.write(f'[{level}] {msg}\n')

    def critical(self, msg):
        self._write_log('CRITICAL', msg)

    def error(self, msg):
        self._write_log('ERROR', msg)

    def warn(self, msg):
        self._write_log('WARNING', msg)

    def info(self, msg):
        self._write_log('INFO', msg)

    def debug(self, msg):
        self._write_log('DEBUG', msg)


class SingletonLogger:
    instance = None
    file = 'log.txt'

    def __new__(cls):
        if not SingletonLogger.instance:
            SingletonLogger.instance = Logger(SingletonLogger.file)
        return SingletonLogger.instance
    
    def __getattr__(self, name: str) -> Any:
        return getattr(self.instance, name)
    
    def __setattr__(self, name: str) -> Any:
        return setattr(self.instance, name)


class MyLogger:
    _logger = None
    file = 'log.txt'

    def __new__(cls, *args, **kwargs):
        if cls._logger is None:
            print("Logger new")
            cls._logger = Logger(cls.file)
        return cls._logger



if __name__ == "__main__":
    logger = SingletonLogger()
    logger.info("Hello, Logger")
    logger = SingletonLogger()
    logger.debug("bug occured")

    logger = MyLogger()
    logger.info("Hello, MyLogger")
    logger = MyLogger()
    logger.debug("bug occured MyLogger")

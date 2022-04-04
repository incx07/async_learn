import platform
import socket
import re
import uuid


def get_sysinfo():
    """Print some information about the system"""
    info={}
    info['platform']=platform.system()
    info['platform-release']=platform.release()
    info['platform-version']=platform.version()
    info['architecture']=platform.machine()
    info['hostname']=socket.gethostname()
    info['ip-address']=socket.gethostbyname(socket.gethostname())
    info['mac-address']=':'.join(re.findall('..', '%012x' % uuid.getnode()))
    info['processor']=platform.processor()
    for key in info:
        print(f'{key}: {info[key]}')

get_sysinfo()


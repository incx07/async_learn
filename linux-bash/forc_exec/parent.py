'''Parent script to run a new program in a child process'''
import os


def run_child(*args, **kwargs):
    '''
    Create a child process (will be replaced with a new program)
    and pass it all the arguments
    '''
    pid = os.fork()
    if pid == 0:
        os.execlp('python3', 'python3', 'child.py', *args, **kwargs)
    else:
        return pid


def main():
    '''Create a parent process'''
    string = input('Enter your string: ')
    child_pid = run_child(string)
    print(f'PID of parent: {os.getpid()}, PID of child: {child_pid}.')


if __name__ == '__main__':
    main()

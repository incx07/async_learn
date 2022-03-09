'''Script to traine os.pipe() method'''
import os


r, w = os.pipe()
pid = os.fork()

command = b'echo'
args = 'my string'

if pid:
    # This is the parent process
    os.close(r)
    print('Parent process is writing')
    os.write(w, command)
    print('Execute program:', command.decode())
    print('String to pass:', args)

else:
    # This is the child process
    os.close(w)
    print('Child Process is reading')
    command = os.fdopen(r).read()
    os.execlp(command, command, args)

from subprocess import Popen, PIPE, STDOUT

cmd = ['/usr/bin/python','/home/aron/Documents/application/Python/34.py']
f = open ('boo','w+')
p = Popen(cmd,stderr=f, close_fds=True)

print 'fuck off'

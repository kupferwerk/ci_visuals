'''
   Simple socket server using threads
'''

import socket
import sys
import signal
from thread import *

HOST = 'localhost'   # Symbolic name meaning all available interfaces
PORT = 8888 # Arbitrary non-privileged port

def set_colors(socket_data):
    print 'Received Data' + str(len(socket_data))
    for s in socket_data:
        print int(s.encode('hex'), 16)

def start_socket():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print 'Socket created'

    #Bind socket to local host and port
    try:
       s.bind((HOST, PORT))
    except socket.error as msg:
       print 'Bind failed. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
       sys.exit()

    print 'Socket bind complete'

    # register ctrl-c callback handler to close socket gracefully
    def signal_handler(signal, frame):
        print('You pressed Ctrl+C!')
        s.close()
        sys.exit(0)
    signal.signal(signal.SIGINT, signal_handler)

    # Start listening on socket
    s.listen(10)
    print 'Socket now listening'

    # Function for handling connections. This will be used to create threads
    def clientthread(conn):
       # Sending message to connected client
       conn.send('Welcome to the server. Type something and hit enter\n') #send only takes string

       # infinite loop so that function do not terminate and thread do not end.
       while True:

           #Receiving from client
           data = conn.recv(4096)
           print data
           if not data:
               break
           set_colors(data)

       #came out of loop
       conn.close()

    #now keep talking with the client
    while 1:
       #wait to accept a connection - blocking call
       conn, addr = s.accept()
       print 'Connected with ' + addr[0] + ':' + str(addr[1])

       #start new thread takes 1st argument as a function name to be run, second is the tuple of arguments to the function.
       start_new_thread(clientthread ,(conn,))

    s.close()

start_socket()

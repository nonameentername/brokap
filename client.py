#!/usr/bin/env python

import socket

UDP_PORT = 7000

sock = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.setblocking(0)
sock.bind( ("127.0.0.1", UDP_PORT) )


while True:
    try:
        data = sock.recv( 1024 )
        print (data)
    except:
        pass

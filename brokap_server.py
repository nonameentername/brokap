import json
import os
import socket
import time
from brokap import Kinect

UDP_PORT = 7000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind( ("127.0.0.1", UDP_PORT) )

if __name__ == '__main__':
    kinect = Kinect()
    while True:
        kinect.poll()

        for name in kinect.ITEMS:
            data = json.dumps({
                'name': name,
                'position': kinect.get_position(name),
                'rotation': kinect.get_rotation(name)
            })
            sock.sendto(data.encode(), ('127.0.0.1', UDP_PORT))

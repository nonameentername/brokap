#!/usr/bin/env python3.3
from brokap import Kinect

kinect = Kinect()

while True:
    kinect.poll()
    print (kinect.get_position('head'))

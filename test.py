#!/usr/bin/env python3.2
from brokap import Kinect

kinect = Kinect()
kinect.poll()
print (kinect.get_position('head'))
print (kinect.get_rotation(Kinect.ITEMS[0]))

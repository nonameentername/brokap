#!/usr/bin/env python
from tracker import Tracker

t = Tracker()
t.initialize()

while True:
    t.update()

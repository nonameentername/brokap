#!/usr/bin/env python
from tracker import Tracker

t = Tracker()
t.poll()
print t.getRot(t.ITEMS[0])
print t.getRot('neck')

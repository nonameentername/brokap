#!/usr/bin/env ppython

from direct.showbase.ShowBase import ShowBase
from direct.task import Task
from pandac.PandaModules import PNMPainter
from pandac.PandaModules import PNMImage
from pandac.PandaModules import PNMBrush
from pandac.PandaModules import VBase4D
from tracker import Tracker
from panda3d.core import *
from pandac.PandaModules import CardMaker
#import ipdb; ipdb.set_trace()

class MyApp(ShowBase):
    def __init__(self):
        ShowBase.__init__(self)
        self.taskMgr.add(self.update, 'update')
        self.tracker = Tracker()

        self.tracker.poll()
        self.w = self.tracker.width
        self.h = self.tracker.height

        self.image = PNMImage(self.w, self.h)
        self.paint = PNMPainter(self.image)
        self.texture = Texture()
        self.texture.load(self.image)

        cm = CardMaker('card')
        cm.setFrame(-30, 30, -30, 30)
        self.card = self.render.attachNewNode(cm.generate())
        self.card.reparentTo(self.render)
        self.card.setTexture(self.texture)
        self.card.setPos(0, 0, 0);
        self.card.lookAt(-1, 0, 0)

    def getBrush(self, color):
        color = VBase4D(1, 0, 0, 1)
        return PNMBrush.makeSpot(color, 1, True, PNMBrush.BEDarken)

    def update(self, task):
        self.tracker.poll()

        for h in range(0, self.h):
            for w in range(0, self.w):
                color = self.tracker.data[h * self.h + w]
                self.paint.setPen(self.getBrush(color))
                self.paint.drawPoint(w, h)

        return Task.cont

app = MyApp()
app.run()

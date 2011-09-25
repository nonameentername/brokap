from libcpp.vector cimport vector

cdef extern from "data.h":
    cdef cppclass Joint:
        vector[float] position
        vector[float] rotation

    cdef cppclass Player:
        vector[Joint] joints

    cdef cppclass Data:
        int width
        int height
        long data
        vector[Player] players
        Data()

cdef extern from "tracker.h":
    cdef cppclass Tracker:
        Tracker()
        int initialize()
        Data poll()

cdef class Kinect:
    cdef Tracker *ptr
    cdef int width
    cdef int height
    cdef long data
    cdef object _players

    ITEMS = [
        'head',
        'neck',
        'torso',
        'waist',
        'left_collar',
        'left_shoulder',
        'left_elbow',
        'left_wrist',
        'left_hand',
        'left_fingertip',
        'right_collar',
        'right_shoulder',
        'right_elbow',
        'right_wrist',
        'right_hand',
        'right_fingertip',
        'left_hip',
        'left_knee',
        'left_ankle',
        'left_foot',
        'right_hip',
        'right_knee',
        'right_ankle',
        'right_foot',
    ]

    def __cinit__(self):
        self.ptr = new Tracker()
        self.ptr.initialize()
        data = self.ptr.poll()
        self.width = data.width
        self.height = data.height
        self.data = data.data

    def __dealloc__(self):
        del self.ptr

    def poll(self):
        data = self.ptr.poll()
        self._players = []

        for i in range(0, data.players.size()):
            data.players[i]
            new_player = {}
            new_player['joints'] = []

            for j in range(0, data.players[i].joints.size()):
                new_joint = {}
                new_joint['position'] = []
                for k in range(0, data.players[i].joints[j].position.size()):
                    new_joint['position'].append(data.players[i].joints[j].position[k])
                   
                for k in range(0, data.players[i].joints[j].rotation.size()):
                    new_joint['rotation'].append(data.players[i].joints[j].rotation[k])
                new_player['joints'].append(new_joint)

            self._players.append(new_player)

    def get_position(self, name):
        index = Kinect.ITEMS.index(name)
        if len(self._players) > 0:
            return self._players[0]['joints'][index].position
        return [0] * 3

    def _get_rotation(self, name):
        index = Kinect.ITEMS.index(name)
        if len(self._players) > 0:
            return self._players[0]['joints'][index].rotation
        return [0] * 9

    def get_rotation(self, name):
        r = self._get_rotation(name)
        return (r[0:3], r[3:6], r[6:9])

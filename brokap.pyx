from libcpp.vector cimport vector
from os import environ
from os import path

DEF TOTALSIZE = 921600

cdef extern from "string" namespace "std":
    cdef cppclass string:
        string(char* s)
        char* c_str()

cdef extern from "data.h":
    cdef cppclass Joint:
        vector[float] position
        vector[float] rotation

    cdef cppclass Player:
        vector[Joint] joints

    cdef cppclass Data:
        int width
        int height
        vector[Player] players
        Data()

cdef extern from "tracker.h":
    cdef cppclass Tracker:
        float data[TOTALSIZE]
        Tracker()
        int initialize(string config_file)
        Data poll()

cdef class Kinect:
    cdef Tracker *ptr
    cdef int _width
    cdef int _height
    cdef object _data
    cdef object _players
    cdef object _items

    ITEMS = [
        'head',
        'neck',
        'torso',
        #'waist',

        #'left_collar',
        'left_shoulder',
        'left_elbow',
        #'left_wrist',
        'left_hand',
        #'left_fingertip',

        #'right_collar',
        'right_shoulder',
        'right_elbow',
        #'right_wrist',
        'right_hand',
        #'right_fingertip',

        'left_hip',
        'left_knee',
        #'left_ankle',
        'left_foot',

        'right_hip',
        'right_knee',
        #'right_ankle',
        'right_foot',
    ]

    def __cinit__(self):
        self.ptr = new Tracker()
        brokap_home = environ['BROKAP_HOME']
        config_file = path.join(brokap_home, 'SamplesConfig.xml').encode('UTF-8')
        self.ptr.initialize(string(config_file))
        data = self.ptr.poll()
        self._width = data.width
        self._height = data.height

        self._items = [
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
                new_joint['rotation'] = []

                for k in range(0, data.players[i].joints[j].position.size()):
                    new_joint['position'].append(data.players[i].joints[j].position[k]/100)

                for k in range(0, data.players[i].joints[j].rotation.size()):
                    new_joint['rotation'].append(data.players[i].joints[j].rotation[k])
                new_player['joints'].append(new_joint)

            self._players.append(new_player)

        self._data = []
        for i in range(0, TOTALSIZE):
            self._data.append(self.ptr.data[i])

    def get_position(self, name):
        index = self._items.index(name)
        try:
            p = self._players[0]['joints'][index]['position']
            return [p[0], p[2], p[1]]
        except:
            return [0] * 3

    def _get_rotation(self, name):
        index = self._items.index(name)
        try:
            return self._players[0]['joints'][index]['rotation']
        except:
            return [0] * 9

    def get_rotation(self, name):
        r = self._get_rotation(name)
        return (r[0:3], r[3:6], r[6:9])

    def get_width(self):
        return self._width

    def get_height(self):
        return self._height

    def get_data(self):
        return self._data

from libcpp.list cimport list

cdef extern from "data.h":
    cdef cppclass Joint:
        list[float] position
        list[float] rotation

    cdef cppclass Player:
        list[Joint] joints

    cdef cppclass Data:
        int width
        int height
        long data
        list[Player] players
        Data()

cdef extern from "tracker.h":
    cdef cppclass Tracker:
        Tracker()
        int initialize()
        void poll()

cdef class PyTracker:
    cdef Tracker *ptr

    def __cinit__(self):
        self.ptr = new Tracker()

    def __dealloc__(self):
        del self.ptr

    def initialize(self):
        self.ptr.initialize()

    def poll(self):
        self.ptr.poll()

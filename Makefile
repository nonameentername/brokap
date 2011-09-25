CC = g++
FLAGS = -fPIC -shared
SOURCE = tracker.cpp tracker_wrap.cpp SceneDrawer.cpp data.cpp
INCLUDE = -I$(HOME)/source/kinect/OpenNI/Include `pkg-config python3 --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python3 --libs`

all: cython
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o tracker_wrap.so

cython: tracker_wrap.pyx
	cython --cplus tracker_wrap.pyx

clean:
	rm tracker_wrap.so tracker_wrap.cpp tracker_wrap.pyc *.pyc

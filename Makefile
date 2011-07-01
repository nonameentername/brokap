CC = g++
FLAGS = -fPIC -shared
SOURCE = tracker.cpp tracker_wrap.cxx SceneDrawer.cpp
INCLUDE = -I$(HOME)/source/kinect/OpenNI/Include `pkg-config python --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python --libs`

all: swig
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o _tracker.so

swig: tracker.i
	swig -python -c++ tracker.i

clean:
	rm _tracker.so tracker_wrap.cxx tracker.py*

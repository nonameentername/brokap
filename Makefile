CC = g++
FLAGS = -fPIC -shared
SOURCE = tracker.cpp tracker_wrap.cxx SceneDrawer.cpp data.cpp
INCLUDE = -I$(HOME)/source/kinect/OpenNI/Include `pkg-config python3 --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python3 --libs`

all: swig
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o _tracker_wrap.so

swig: tracker.i
	swig -c++ -python -py3 tracker.i

clean:
	rm _tracker_wrap.so tracker_wrap.cxx tracker_wrap.py* *.pyc

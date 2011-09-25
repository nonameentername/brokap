CC = g++
FLAGS = -fPIC -shared
SOURCE = tracker.cpp brokap.cpp SceneDrawer.cpp data.cpp
INCLUDE = -I$(HOME)/source/kinect/OpenNI/Include `pkg-config python3 --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python3 --libs`

all: cython
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o brokap.so

cython: brokap.pyx
	cython --cplus brokap.pyx

clean:
	rm brokap.so brokap.cpp *.pyc

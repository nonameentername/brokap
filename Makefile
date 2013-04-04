CC = g++
FLAGS = -fPIC -shared -g -O0
SOURCE = tracker.cpp brokap.cpp SceneDrawer.cpp data.cpp
INCLUDE = -I./kinect/OpenNI/Include `pkg-config python-3.3 --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python-3.3 --libs`

all: cython
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o brokap.so

cython: brokap.pyx
	cython --cplus brokap.pyx

clean:
	rm brokap.so brokap.cpp *.pyc

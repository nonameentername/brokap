CC = g++
FLAGS = -fPIC -g -O0
SOURCE = tracker.cpp brokap.cpp SceneDrawer.cpp data.cpp
INCLUDE = -I./kinect/OpenNI/Include `pkg-config python-3.6 --cflags`
LIBS = -lOpenNI -lglut -lGL `pkg-config python-3.6 --libs`

all: cython
	$(CC) $(FLAGS) $(SOURCE) $(INCLUDE) $(LIBS) -o brokap_server

cython: brokap.pyx
	cython --cplus brokap.pyx --embed

bootstrap:
	./bootstrap.sh

clean:
	rm -rf brokap.so brokap.cpp *.pyc

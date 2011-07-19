#ifndef _data_h
#define _data_h

#include <list>

class Joint {
public:
    std::list<float> position;
    std::list<float> rotation;
};

class Player {
public:
    std::list<Joint> joints;
};

class Data {
private:
public:
    int width;
    int height;
    long data;
    std::list<Player> players;
    Data();
    ~Data();
};

#endif

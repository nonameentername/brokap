#ifndef _tracker_h
#define _tracker_h

#include <XnCppWrapper.h>
#include <string>
#include "data.h"

//TOTALSIZE = (640 * 480 * 3)
#define TOTALSIZE 921600

class Tracker {
private:
    Data jointUpdate();
public:
    Tracker();
    ~Tracker();
    int initialize(std::string config_file);
    float data[TOTALSIZE];
    Data poll();
};

#endif

#ifndef _tracker_h
#define _tracker_h

#include <XnCppWrapper.h>
#include "data.h"

class Tracker {
public:
    float *data;
    Tracker();
    ~Tracker();
    Data jointUpdate();
    int initialize();
    Data poll();
};

#endif

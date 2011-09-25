#ifndef _tracker_h
#define _tracker_h

#include <XnCppWrapper.h>
#include "data.h"

class Tracker {
private:
    Data jointUpdate();
public:
    float *data;
    Tracker();
    ~Tracker();
    int initialize();
    Data poll();
};

#endif

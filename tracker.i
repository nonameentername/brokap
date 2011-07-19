%module tracker_wrap
%include "std_string.i"
%include "std_list.i"
%{
#include "data.h"
#include "tracker.h"
%}
%include "data.h"
%include "tracker.h"

namespace std {
    %template(FloatList) list<float>;
    %template(DataList) list<unsigned short>;
    %template(JointList) list<Joint>;
    %template(PlayerList) list<Player>;
}

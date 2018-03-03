Brokap
======

Blender motion capture
----------------------

Motion capture for blender using Xbox 360 Kinect

To build this project you will need to build OpenNI:

    make bootstrap

To build `brokap_server` in ubuntu:

    pyenv virtualenv 3.6.3 brokap
    pyenv shell brokap
    pip install -r requirements.txt
    make

Ubuntu automatically registers `gspca_kinect` module for the Kinect.
This module needs to be removed to avoid conflict with `brokap_server`

    rmmod gspca_kinect

Start the `brokap_server`:

    ./brokap_server

`brokap_blender.py` can then be added to blender to allow motion capture:

    File -> User Preferences -> Add-ons tab -> Install from file ...

The blender add-on will then be found under the tools section in Brokap tab.
The following actions are available:

    Create - Adds a new set of empties for motion capture
    Start - Starts motion capture from brokap_server
    Stop - Stops motion capture from brokap_server

The udp packets can be recorded and played back using tcpdump and udpreplay:
https://github.com/rigtorp/udpreplay.git

    sudo tcpdump -i lo udp port 7000 -w dump.pcap
    udpreplay -i <interface> dump.pcap

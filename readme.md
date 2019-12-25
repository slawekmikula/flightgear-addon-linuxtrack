# About

Linuxtrack add-on for FlightGear Flight Simulator. Enables communication with
Linuxtrack software. It is add-on encapsulation for protocol included in the
original software https://github.com/uglyDwarf/linuxtrack/tree/master/doc/fgfs

# Istallation

- extract zip (if downloaded as a zip) to a given location. For example let's
  say we have /myfolder/addons/thisaddon with contents of this addon.
- run flightgear with --addon directive or add it in the Launcher application
  in 'Add-On' section.

Code:
```
    ./fgbin/bin/fgfs --fg-root=./fgdata --launcher --prop:/sim/fg-home=/myfolder/flightgear/fghome --addon="/myfolder/addons/thisaddon"
```

# Usage

First configure LinuxTrack with it's GUI configuration. There you can test if
the selected tracking device is working and save the configuration. After that
you can run the PIPE software which feeds the data through UDP protocol. Run it
with `--output-net-udp --format-flightgear` code. Running linuxtrack via helper
script. It should be saved into e.g. run_ltr.sh script. After running it the
tracking device should be turned on.

Code:
```
 #!/bin/bash
 PATH=/opt/linuxtrack-0.99.18
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PATH/lib/:$PATH/lib/linuxtrack
 $PATH/bin/ltr_pipe --output-net-udp --format-flightgear
```

Next start FlightGear. Go to menu `Settings -> Linuxtrack`. There configure
settings for the UDP protocol. When running with defaults on the same machine
you can keep the settings not touched. There you can enable linuxtrack protocol.
After that it should start track head movement. Have fun !

# History

- 0.0.1 - first public version on github


# Authors

- Slawek Mikula - source code
- uglyDwarf - linuxtrack protocol definition

# Links

- https://github.com/uglyDwarf/linuxtrack - linux head tracking software

# License

GNU General Public License version 2

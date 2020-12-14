#
# LinuxTrack addon
#
# Author: Slawek Mikula
# Started on September 2018

var main = func( addon ) {
    var root = addon.basePath;

    # enable persistent settings save into userarchive data
    var enabledMode = props.globals.getNode("/sim/linuxtrack/enabled", 1);
    enabledMode.setAttribute("userarchive", "y");
    if (enabledMode.getValue() == nil) {
      enabledMode.setValue(1);
    }

    var trackAll = props.globals.getNode("/sim/linuxtrack/track-all", 1);
    trackAll.setAttribute("userarchive", "y");
    if (trackAll.getValue() == nil) {
      trackAll.setValue(1);
    }

    props.globals.getNode("/sim/linuxtrack/track-x", 1).setAttribute("userarchive", "y");
    props.globals.getNode("/sim/linuxtrack/track-y", 1).setAttribute("userarchive", "y");
    props.globals.getNode("/sim/linuxtrack/track-z", 1).setAttribute("userarchive", "y");

    # load scripts
    foreach(var f; ['linuxtrack.nas'] ) {
        io.load_nasal( root ~ "/nasal/" ~ f, "linuxtrack" );
    }

    var initProtocol = func() {
        var protocolstring = "generic,socket,in,200,,6543,udp,linuxtrack";
        fgcommand("add-io-channel",
          props.Node.new({
              "config" : protocolstring,
              "name" : "linuxtrack"
          })
        );

        linuxtrack.regviews();
    };

    var shutdownProtocol = func() {
        fgcommand("remove-io-channel",
          props.Node.new({
              "name" : "linuxtrack"
          })
        );
    }

    var init = _setlistener("/sim/linuxtrack/enabled", func() {
        if (getprop("/sim/linuxtrack/enabled") == 1) {
            initProtocol();
        } else {
            shutdownProtocol();
        }
    });

    var init = _setlistener("/sim/signals/fdm-initialized", func() {
        removelistener(init); # only call once
        if (getprop("/sim/linuxtrack/enabled") == 1) {
            initProtocol();
        }
    });

    var reinit_listener = _setlistener("/sim/signals/reinit", func {
        removelistener(reinit_listener); # only call once
        if (getprop("/sim/linuxtrack/enabled") == 1) {
            initProtocol();
        }
    });

    var exit = _setlistener("/sim/signals/exit", func() {
        removelistener(exit); # only call once
        if (getprop("/sim/linuxtrack/enabled") == 0) {
            shutdownProtocol();
        }
    });
}

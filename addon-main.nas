#
# LinuxTrack addon
#
# Author: Slawek Mikula
# Started on September 2018

var main = func( addon ) {
    var root = addon.basePath;
    var my_addon_id  = "com.slawekmikula.flightgear.LinuxTrack";
    var my_version   = getprop("/addons/by-id/" ~ my_addon_id ~ "/version");
    var my_root_path = getprop("/addons/by-id/" ~ my_addon_id ~ "/path");
    var my_settings_root_path = "/addons/by-id/" ~ my_addon_id ~ "/addon-devel/";

    # enable persistent settings save into userarchive data
    var enabledMode = props.globals.getNode("/sim/linuxtrack/enabled", 1);
    enabledMode.setAttribute("userarchive", "y");
    if (enabledMode.getValue() == nil) {
      enabledMode.setValue("true");
    }

    var trackAll = props.globals.getNode("/sim/linuxtrack/track-all", 1);
    trackAll.setAttribute("userarchive", "y");
    if (trackAll.getValue() == nil) {
      trackAll.setValue("true");
    }

    props.globals.getNode("/sim/linuxtrack/track-x", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-y", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-z", 1).setAttribute("userarchive", 0);

    # load scripts
    foreach(var f; ['linuxtrack.nas'] ) {
        io.load_nasal( root ~ "/nasal/" ~ f, "linuxtrack" );
    }

    var initProtocol = func() {
      if (getprop("/sim/linuxtrack/enabled") == 1) {

        var protocolstring = "generic,socket,in,200,,6543,udp,[addon=" ~ my_addon_id ~ "]/Protocol/linuxtrack";
        fgcommand("add-io-channel",
          props.Node.new({
              "config" : protocolstring,
              "name" : "linuxtrack"
          })
        );

        linuxtrack.regviews();
      }
    };

    var init = _setlistener("/sim/signals/fdm-initialized", func() {
        removelistener(init); # only call once
        initProtocol();
    });

    var reinit_listener = _setlistener("/sim/signals/reinit", func {
        removelistener(reinit_listener); # only call once
        initProtocol();
    });

    var exit = _setlistener("/sim/signals/exit", func() {
      removelistener(exit); # only call once

      fgcommand("remove-io-channel",
        props.Node.new({
            "name" : "linuxtrack"
        })
      );
    });
}

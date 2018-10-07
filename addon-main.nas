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

    # load dialogs
    var dialogs   = ["linuxtrack-settings"];
    forindex (var i; dialogs) {
      gui.Dialog.new("/sim/gui/dialogs/" ~ dialogs[i] ~ "/dialog", my_root_path ~ "/gui/" ~ dialogs[i] ~ ".xml");
    }

    var data = {
	  label   : "LinuxTrack",
      name    : "linuxtrack",
      binding : { command : "dialog-show", "dialog-name" : "linuxtrack-settings" },
      enabled : "true",
	};

    # register in main menu
    foreach(var item; props.getNode("/sim/menubar/default/menu[1]").getChildren("item")) {
      if (item.getValue("name") == "linuxtrack") {
  		    return;
      }
    }

	props.globals.getNode("/sim/menubar/default/menu[1]").addChild("item").setValues(data);

	fgcommand("gui-redraw");

    props.globals.getNode("/sim/linuxtrack/enabled", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-all", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-x", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-y", 1).setAttribute("userarchive", 0);
    props.globals.getNode("/sim/linuxtrack/track-z", 1).setAttribute("userarchive", 0);

    # load scripts
    foreach(var f; ['linuxtrack.nas'] ) {
        io.load_nasal( root ~ "/nasal/" ~ f, "linuxtrack" );
    }

    var init = setlistener("/sim/signals/fdm-initialized", func() {
      removelistener(init); # only call once

      # Must wait some seconds untill the objects from view.nas become fully initialized.
      # TODO: Find a better way for this, may be by using some property checks.
      settimer(linuxtrack.regviews, 2);
    });

}

/*
* Copyright (c) 2011-2018 Fernando Andrade (www.thefernando.net)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Fernando Andrade <fernandofreamunde@gmail.com>
*/

public class MyApp : Gtk.Application {

    public MyApp() {
        Object (
            application_id: "com.github.fernandofreamunde.vman",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        //var button_hello = new Gtk.Button.with_label("Click me!");
        //button_hello.margin = 12;
        //button_hello.clicked.connect(() => {
        //    button_hello.label     = _("Click me ;)");
        //    button_hello.sensitive = false;
        //});

        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width  = 300;
        main_window.title          = _("Vman - Vagrant Manager");

        var layout = new Gtk.Grid();
        layout.orientation    = Gtk.Orientation.VERTICAL;
        layout.row_spacing    = 10;
        layout.column_spacing = 10;

        var box_location_label = new Gtk.Label(_("Location"));
        var box_status_label   = new Gtk.Label(_("Status"));
        var box_provider_label = new Gtk.Label(_("Provider"));
        var box_actions_label  = new Gtk.Label(_("Actions"));

        layout.attach(box_location_label, 0,0,1,1);
        layout.attach(box_status_label,   1,0,1,1);
        layout.attach(box_provider_label, 2,0,1,1);
        layout.attach(box_actions_label,  3,0,5,1);

        VagrantBox[] boxes = getVagrantBoxes();

        //if (boxes.length == 0) {
        //  just display a message stating there are no vms
        //}
        //stdout.printf( "length: %d ...\n", boxes.length );

        int iterator = 1;
        foreach (VagrantBox box in boxes){
            var existing_box_location_label = new Gtk.Label(box.location);

            var existing_box_status_label   = box.getStatus;
            var existing_box_provider_label = new Gtk.Image.from_icon_name (box.provider, Gtk.IconSize.SMALL_TOOLBAR);//new Gtk.Label(box.provider);
            //var existing_box_actions_label  = new Gtk.Label("Actions");

            layout.attach(existing_box_location_label, 0,iterator,1,1);
            layout.attach(existing_box_status_label,   1,iterator,1,1);
            layout.attach(existing_box_provider_label, 2,iterator,1,1);
            //layout.attach(box_actions_label,  3,0,5,1);

            var play_pause_icon = "media-playback-start";
            if (box.status == "running") {
                play_pause_icon =  "media-playback-pause";
            }

            var play_action_button = new Gtk.Button.from_icon_name(play_pause_icon);
            play_action_button.set_tooltip_text(_("Start up/Suspend this Box"));

            var stop_action_button = new Gtk.Button.from_icon_name( "media-playback-stop");
            stop_action_button.set_tooltip_text(_("Power off this Box"));

            var prov_action_button = new Gtk.Button.from_icon_name("application-x-executable");
            prov_action_button.set_tooltip_text(_("Provision this Box"));

            var sshb_action_button = new Gtk.Button.from_icon_name("utilities-terminal");
            sshb_action_button.set_tooltip_text(_("Open ssh session into this Box"));

            var dest_action_button = new Gtk.Button.from_icon_name("window-close");
            dest_action_button.set_tooltip_text(_("Destroy this Box"));

            var dele_action_button = new Gtk.Button.from_icon_name("edit-delete");
            dele_action_button.set_tooltip_text(_("Delete this Box Folder"));             //prompt confirmation

            var indi_action_button = new Gtk.Switch();
            indi_action_button.set_tooltip_text(_("Add indicator for this Box"));



            // delete    : "edit-delete"
            // destroy   : "window-close"

            play_action_button.clicked.connect(() => {
                box.playPauseAction();

                if(box.status != "running") {
                    play_action_button.label = _("Play");
                   // existing_box_status_label.label = "saved";

                }else {
                    play_action_button.label = _("Pause");
                    //existing_box_status_label.label = "running";
                }
                //button.sensitive = false;
            });

            stop_action_button.clicked.connect(() => {
                play_action_button.label = _("Play");
                //existing_box_status_label.label = "poweroff";

                box.stopAction();
                //button.sensitive = false;
            });

            prov_action_button.clicked.connect(() => {
                box.provisionAction();
                //button.sensitive = false;
            });

            sshb_action_button.clicked.connect(() => {
                box.sshAction();
                //button.sensitive = false;
            });

            dest_action_button.clicked.connect(() => {
                box.destroyAction();
            });

            dele_action_button.clicked.connect(() => {
                box.deleteAction();
            });

            indi_action_button.notify["active"].connect (() => {
			    box.indicatorAction();
		    });

            layout.attach(play_action_button, 4,iterator,1,1);
            layout.attach(stop_action_button, 5,iterator,1,1);
            layout.attach(prov_action_button, 6,iterator,1,1);
            layout.attach(sshb_action_button, 7,iterator,1,1);
            layout.attach(dest_action_button, 8,iterator,1,1);
            layout.attach(dele_action_button, 9,iterator,1,1);
            layout.attach(indi_action_button, 10,iterator,1,1);

            iterator++;
        }

        ///////////////////////////////////////////////////////////////////////////////////////
        //var hello_button = new Gtk.Button.with_label( _("Click me!"));
        //var hello_label = new Gtk.Label(null);
        //
        //var rotate_button = new Gtk.Button.with_label( _("Rotate!"));
        //var rotate_label = new Gtk.Label( _("Horizontal") );
        //
        //
        ////layout.add(button);
        //layout.attach(hello_button, 1,1,1,1);
        ////layout.add(label);
        //layout.attach_next_to(hello_label, hello_button, Gtk.PositionType.RIGHT, 1, 1);
        //
        //layout.attach(rotate_button, 1,2,1,1);
        //layout.attach_next_to(rotate_label, rotate_button, Gtk.PositionType.RIGHT, 1, 1);
        ///////////////////////////////////////////////////////////////////////////////////////
        main_window.add(layout);

        //hello_button.clicked.connect(() => {
        //    hello_label.label = newLabel(hello_label.label);
        //    //button.sensitive = false;
        //});

        //rotate_button.clicked.connect (() => {
        //    rotate_label.angle = 90;
        //    rotate_label.label = _("Vertical");
        //    rotate_button.sensitive = false;
        //});

        main_window.show_all();
    }

    //private static string newLabel(string currntLabel) {
    //    if (currntLabel == _("Hello I'm Vman")) {
    //        return _("Hello I'm Vman again!");
    //    }
    //    else{
    //        return _("Hello I'm Vman");
    //    }
    //}

    private static VagrantBox[] getVagrantBoxes() {
        string ls_stdout;
	    string ls_stderr;
	    int ls_status;

        try {
		    Process.spawn_command_line_sync ("vagrant global-status | grep $HOME",
									out ls_stdout,
									out ls_stderr,
									out ls_status);
	    } catch (SpawnError e) {
		    stdout.printf ("Error: %s\n", e.message);
	    }

        VagrantBox[] boxes = {};
	    try {

		    Regex regex = /([\w,\d]{7})\s\s(\w*)\s(\w*)\s\s?(\w*)\s\s?(\/home\/[\w,\S]*)/;

		    if (regex.match (ls_stdout)){
			    MatchInfo match_info;

			    regex.match_full (ls_stdout, -1, 0, 0, out match_info);

			    //stdout.printf((match_info.get_match_count()).to_string() + "\n");

			    while (match_info.matches()){

				    string[] boxInfo = match_info.fetch_all();
				    //string[] box;

				    var newbox      = new VagrantBox();
                    newbox.id       = boxInfo[1];
                    newbox.name     = boxInfo[2];
                    newbox.provider = boxInfo[3];
                    newbox.status   = boxInfo[4];
                    newbox.location = boxInfo[5];

                    boxes += newbox;

				    match_info.next();
			    }

		    }

	    } catch (RegexError e) {
		    stdout.printf ("Error %s\n", e.message);
	    }

	    return boxes;
    }

    public static int main (string[] args){
        var app = new MyApp();
        return app.run(args);
    }
}

class VagrantBox {

    private string _id;
    private string _name;
    private string _provider;
    private string _status;
    private string _location;
    
    private string[] _possible_status = {"running", "saved", "poweroff"};

    public string id {
        get { return _id; }
        set { _id = value; }
    }

    public string name {
        get { return _name; }
        set { _name = value; }
    }

    public string provider {
        get { return _provider; }
        set { _provider = value; }
    }

    public string status {
        get { return _status; }
        set { _status = value; }
    }

    public string location {
        get { return _location; }
        set { _location = value; }
    }

    public void playPauseAction() {
        var action = "up";

        if (_status == "running") {
            _status = "saved";
            action = "suspend";
        } else {
            _status = "running";
        }

        stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }
    
    public void getStatus() {
        if (_status == "saved"){}
        
        if (_status == "poweroff"){}
        
        if (_status == "running"){}
        
        image = new Gtk.Image.from_icon_name ("user-offline", Gtk.IconSize.SMALL_TOOLBAR);
        image.set_tooltip_text(_("box is <state>"));
       return image
    }

    public void stopAction() {
        var action = "halt";
        stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }

    public void provisionAction() {
        var action = "provision";
        stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }

    public void sshAction() {
        //var action = "ssh";
        //stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        //runAction(action);
    }

    public void destroyAction() {
        //var action = "destroy";
        //stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        //runAction(action, true);
    }

    public void deleteAction() {
        //var action = "halt";
        //stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        //runAction(action);
    }

    public void indicatorAction() {
        //var action = "halt";
        //stdout.printf("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        //runAction(action);
    }

    private void runAction(string action, bool force = false) {

        string[] argv = {"vagrant", action, _id};

        if (force) {
            string[] argv = {"vagrant", action, _id, "-y"};
        }

        string[] envv = Environ.get();
        int child_pid;
        int child_stdin_fd;
        int child_stdout_fd;
        int child_stderr_fd;

        Process.spawn_async_with_pipes(
            ".",
            argv,
            envv,
            SpawnFlags.SEARCH_PATH,
            null,
            out child_pid,
            out child_stdin_fd,
            out child_stdout_fd,
            out child_stderr_fd);
    }
}


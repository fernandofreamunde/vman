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
            var existing_box_status_label   = box.getStatus();
            var existing_box_provider_label = box.getProvider();
            //var existing_box_actions_label  = new Gtk.Label("Actions");

            layout.attach(existing_box_location_label, 0,iterator,1,1);
            layout.attach(existing_box_status_label,   1,iterator,1,1);
            layout.attach(existing_box_provider_label, 2,iterator,1,1);
            layout.attach(box.getActionsWidget(),      3,iterator,1,1);


            iterator++;
        }

        main_window.add(layout);

        main_window.show_all();
    }

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
            warning ("Error: %s\n", e.message);
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
            warning ("Error %s\n", e.message);
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

        info("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }

    private void updatePlayPauseButton(Gtk.Button button) {
        var play_pause_icon = "media-playback-start";
        if (_status == "running") {
            play_pause_icon =  "media-playback-pause";
        }

        button.set_image (new Gtk.Image.from_icon_name (play_pause_icon, Gtk.IconSize.SMALL_TOOLBAR));
    }

    private Gtk.Button getPlayPauseButton() {

        var play_pause_icon = "media-playback-start";
        if (_status == "running") {
            play_pause_icon =  "media-playback-pause";
        }

        var play_action_button = new Gtk.Button.from_icon_name(play_pause_icon);
        play_action_button.set_tooltip_text(_("Start up/Suspend this Box"));

        play_action_button.clicked.connect(() => {
            playPauseAction();

            updatePlayPauseButton(play_action_button);
        });

        return play_action_button;
    }

    private Gtk.Button getStopButton(Gtk.Button playButton) {

        var stop_action_button = new Gtk.Button.from_icon_name( "media-playback-stop");
        stop_action_button.set_tooltip_text(_("Power off this Box"));

        stop_action_button.clicked.connect(() => {
            updatePlayPauseButton(playButton);

            stopAction();
        });

        return stop_action_button;
    }

    private Gtk.Button getProvisionButton() {

        var prov_action_button = new Gtk.Button.from_icon_name("application-x-executable");
        prov_action_button.set_tooltip_text(_("Provision this Box"));

        prov_action_button.clicked.connect(() => {
            provisionAction();
        });

        return prov_action_button;
    }

    private Gtk.Button getSshButton() {

        var sshb_action_button = new Gtk.Button.from_icon_name("utilities-terminal");
        sshb_action_button.set_tooltip_text(_("Open ssh session into this Box"));

        sshb_action_button.clicked.connect(() => {
            sshAction();
        });

        return sshb_action_button;
    }

    private Gtk.Button getDestroyButton() {

        var dest_action_button = new Gtk.Button.from_icon_name("window-close");
        dest_action_button.set_tooltip_text(_("Destroy this Box"));

        dest_action_button.clicked.connect(() => {
            destroyAction();
        });

        return dest_action_button;
    }

    private Gtk.Button getDeleteButton() {

        var dele_action_button = new Gtk.Button.from_icon_name("edit-delete");
        dele_action_button.set_tooltip_text(_("Delete this Box Folder"));             //prompt confirmation

        dele_action_button.clicked.connect(() => {
            deleteAction();
        });

        return dele_action_button;
    }

    private Gtk.Switch getIndicatorSwitch() {

        var indi_action_button = new Gtk.Switch();
        indi_action_button.set_tooltip_text(_("Add indicator for this Box"));

        // save to config file.

        indi_action_button.notify["active"].connect (() => {
            indicatorAction();
        });

        return indi_action_button;
    }

    public Gtk.Box getActionsWidget() {
        Gtk.Box widgetBox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

        var playPauseButton = getPlayPauseButton();
        widgetBox.pack_start(playPauseButton);

        widgetBox.pack_start(getStopButton(playPauseButton));

        widgetBox.pack_start(getProvisionButton());

        widgetBox.pack_start(getSshButton());

        widgetBox.pack_start(getDestroyButton());

        widgetBox.pack_start(getDeleteButton());

        //widgetBox.pack_start(getIndicatorSwitch());

        return widgetBox;
    }

    public Gtk.Image getStatus() {
        Gtk.Image image = new Gtk.Image();
        if (_status == "saved"){
            image = new Gtk.Image.from_icon_name ("user-idle", Gtk.IconSize.SMALL_TOOLBAR);
            image.set_tooltip_text(_status);
        }

        if (_status == "poweroff"){
            image = new Gtk.Image.from_icon_name ("user-busy", Gtk.IconSize.SMALL_TOOLBAR);
            image.set_tooltip_text(_status);
        }

        if (_status == "running"){
            image = new Gtk.Image.from_icon_name ("user-available", Gtk.IconSize.SMALL_TOOLBAR);
            image.set_tooltip_text(_status);
        }

       return image;
    }

    public Gtk.Image getProvider() {
        return new Gtk.Image.from_icon_name (_provider, Gtk.IconSize.SMALL_TOOLBAR);
    }

    public void stopAction() {
        var action = "halt";
        info("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }

    public void provisionAction() {
        var action = "provision";
        info("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action);
    }

    public void sshAction() {
        //var action = "ssh";
        info("the box %s will run the command: vagrant ssh %s \n", _id, _id);

        string command = "pantheon-terminal -e 'vagrant ssh " + _id + "'";

         AppInfo.create_from_commandline (command, null, AppInfoCreateFlags.NONE).launch (null, null);
    }

    public void destroyAction() {
        var action = "destroy";
        info("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action, true);
    }

    public void deleteAction() {
        var action = "delete";
        info("the box %s will run the command: vagrant %s %s \n", _id, action, _id);

        runAction(action, true);
    }

    public void indicatorAction() {
        info("Should create an indicator for the box %s \n", _id);
    }

    private void runAction(string action, bool force = false) {

        string[] argv = {"vagrant", action, _id};

        if (force) {
            argv = {"vagrant", action, _id, "-y"};
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


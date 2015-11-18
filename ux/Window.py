#!/usr/bin/python

from gi.repository import Gtk, Gio

class Window(Gtk.Window):
    """docstring for HeaderBarWindow"""
    def __init__(self):
        #starts the window
        Gtk.Window.__init__(self, title = "Vman")
        self.set_border_width(2)
        self.set_default_size(500, 200)

        #sets the heatherbar
        hb = Gtk.HeaderBar()
        hb.set_show_close_button(True)
        hb.props.title = "Vman"
        self.set_titlebar(hb)

        #######################self.add(Gtk.TextView())

        vbox =Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)

        stack = Gtk.Stack()
        stack.set_transition_duration(1000)
        #set transition accepts values from 0 to 19
        #more info http://lazka.github.io/pgi-docs/Gtk-3.0/enums.html#Gtk.StackTransitionType
        stack.set_transition_type(6)

        listbox = Gtk.ListBox()
        listbox.set_selection_mode(Gtk.SelectionMode.NONE)
        #hbox.pack_start(listbox, True, True, 0)
        stack.add_titled(listbox, "VagrantBoxes", "Vagrant Boxes")

        for vagrantbox in self.readBoxes():
            row = Gtk.ListBoxRow()
            hbox = Gtk.Box(orientation = Gtk.Orientation.HORIZONTAL)

            label = Gtk.Label()
            label.set_markup(vagrantbox)

            label2 = Gtk.Label()
            label2.set_markup('')

            startButton = Gtk.Button(label="Start")
            startButton.connect("clicked", self.on_startButton_clicked, vagrantbox)
            hbox.pack_end(startButton, True, True, 0)

            suspendButton = Gtk.Button(label="Stop")
            suspendButton.connect("clicked", self.on_suspendButton_clicked, vagrantbox)
            hbox.pack_end(suspendButton, True, True, 0)

            haltButton = Gtk.Button(label="Halt")
            haltButton.connect("clicked", self.on_haltButton_clicked, vagrantbox)
            #hbox.pack_end(haltButton, True, True, 0)

            destroyButton = Gtk.Button(label="Destroy")
            destroyButton.connect("clicked", self.on_destroyButton_clicked, vagrantbox)
            #hbox.pack_end(destroyButton, True, True, 0)

            hbox.add(label)
            hbox.add(label2)
            row.add(hbox)
            listbox.add(row)
            pass

        row = Gtk.ListBoxRow()
        hbox = Gtk.Box(orientation = Gtk.Orientation.HORIZONTAL, spacing = 50)
        add_button = Gtk.Button(label="Add Box")
        add_button.connect("clicked", self.on_addButton_clicked)
        hbox.add(add_button)
        row.add(hbox)
        listbox.add(row)

        checkbutton = Gtk.CheckButton("I agree...")
        stack.add_titled(checkbutton, "check", "Check Button")

        label = Gtk.Label()
        label.set_markup("<big>A fancy label</big>")
        stack.add_titled(label, "label", "A label")

        stack_switcher = Gtk.StackSwitcher()
        stack_switcher.set_stack(stack)
        #hb.pack_start(stack_switcher)
        vbox.pack_start(stack, True, True, 0)

        button = Gtk.Button()
        icon = Gio.ThemedIcon(name="mail-send-receive-symbolic")
        image = Gtk.Image.new_from_gicon(icon, Gtk.IconSize.BUTTON)
        button.add(image)
        hb.pack_end(button)

        button = Gtk.Button()
        icon = Gio.ThemedIcon(name="gtk-execute")
        image = Gtk.Image.new_from_gicon(icon, Gtk.IconSize.BUTTON)
        button.add(image)
        hb.pack_end(button)

    """
    reads the locations of the boxes,
    returns a list with the locations
    """
    def readBoxes(self):
        #file = open('data/boxes')
        print "reading file..."
        with open('data/boxes') as file:
            content = file.readlines()

        print "processing list of boxes..."
        boxesList = []
        for path in content:
                boxesList.append(path[:-1])
        print "boxes list is : "
        print boxesList
        return boxesList
        #print file.read()

    def on_startButton_clicked(self, widget, box):
        print "Start box :" + box

    def on_suspendButton_clicked(self, widget, box):
        print "Suspend box :" + box

    def on_haltButton_clicked(self, widget, box):
        print "Halt box :" + box

    def on_destroyButton_clicked(self, widget, box):
        print "destroy box :" + box

    def on_addButton_clicked(self, widget):
        dialog = Gtk.FileChooserDialog("Please choose a file", self,
            Gtk.FileChooserAction.SELECT_FOLDER,
            (Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
             Gtk.STOCK_OPEN, Gtk.ResponseType.OK))

        #self.add_filters(dialog)

        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            print("Open clicked")
            print("File selected: " + dialog.get_filename())
            #save value to the data file
        elif response == Gtk.ResponseType.CANCEL:
            print("Cancel clicked")

        dialog.destroy()


        #gtk_stack_switcher_get_stack(label)
#Todo: create method to generate the gtk.list objects

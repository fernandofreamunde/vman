#!/usr/bin/python

from gi.repository import Gtk, Gio

class Window(Gtk.Window):
    """docstring for HeaderBarWindow"""
    def __init__(self):
        Gtk.Window.__init__(self, title = "Vman")
        self.set_border_width(2)
        self.set_default_size(500, 200)

        hb = Gtk.HeaderBar()
        hb.set_show_close_button(True)
        #hb.props.title = "Vman"
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
            hbox = Gtk.Box(orientation = Gtk.Orientation.HORIZONTAL, spacing = 50)

            label = Gtk.Label()
            label.set_markup(vagrantbox)

            button1 = Gtk.Button(label="Hello")
            #self.button1.connect("clicked", self.on_button1_clicked)
            hbox.pack_end(button1, True, True, 0)

            hbox.add(label)
            row.add(hbox)
            listbox.add(row)
            pass

        row = Gtk.ListBoxRow()
        hbox = Gtk.Box(orientation = Gtk.Orientation.HORIZONTAL, spacing = 50)
        add_button = Gtk.Button(label="Add Box")
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
        hb.pack_start(stack_switcher)
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

#Todo: create method to generate the gtk.list objects

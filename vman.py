#!/usr/bin/python

from gi.repository import Gtk, Gio
from ux.Window import Window

win = Window()

win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()

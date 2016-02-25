import os
import signal
from gi.repository import Gtk as gtk
from gi.repository import AppIndicator3 as appindicator

APPINDICATOR_ID = 'myappindicator'

def main():
    indicator = appindicator.Indicator.new(APPINDICATOR_ID, os.path.abspath('sample_icon.svg'), appindicator.IndicatorCategory.SYSTEM_SERVICES)
    indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
    indicator.set_menu(build_menu())
    #set_idicator(APPINDICATOR_ID)
    
    gtk.main()

def set_idicator(APPINDICATOR_ID):
    indicator = appindicator.Indicator.new(APPINDICATOR_ID, os.path.abspath('sample_icon.svg'), appindicator.IndicatorCategory.SYSTEM_SERVICES)
    indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
    indicator.set_menu(build_menu())

def build_menu():
    menu = gtk.Menu()

    item_quit = gtk.MenuItem('open_location')
    item_quit.connect('activate', open_location)
    menu.append(item_quit)

    item_quit = gtk.MenuItem('halt')
    item_quit.connect('activate', halt)
    menu.append(item_quit)

    item_quit = gtk.MenuItem('SSH Connect')
    item_quit.connect('activate', ssh)
    menu.append(item_quit)

    item_quit = gtk.MenuItem('Play/pause')
    item_quit.connect('activate', up_suspend)
    menu.append(item_quit)

    separator =  gtk.SeparatorMenuItem()
    menu.append(separator)

    item_quit = gtk.MenuItem('Quit')
    item_quit.connect('activate', quit)
    menu.append(item_quit)

    menu.show_all()
    return menu

def open_location(self):
    print "open_location"

def halt(self):
    print "halt"

def up_suspend(self):
    print "up_suspend"

def ssh(self):
    print "ssh"

def quit(source):
    gtk.main_quit()

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    main()
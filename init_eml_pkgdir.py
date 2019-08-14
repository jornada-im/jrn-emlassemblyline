# init_eml_pkgdir.py
#
# This is a python script to create an emlassemblyline package directory in 
# a selected location.

import tkinter as tk
from tkinter import filedialog
import os

# 
print("Templating a new EMLassemblyline project")

pkgID = input('\nPlease enter the package ID (9 digit number): ')

pkg_shname = input('\nEnter a short package name to append to directory name: ')

pkg_dirname = pkgID + pkg_shname

# Ask for a location to create the new package directory
root = tk.Tk()
root.wm_withdraw()

print("\nPlease select a location for {0}".format(pkg_dirname))
file_path = filedialog.askdirectory(initialdir=os.getcwd(),
    title='Please select a location'.format(pkg_dirname))

root.update()

newdir = os.path.join(file_path, pkg_dirname)


if not os.path.exists(newdir):
    os.makedirs(newdir)

print("....Created {0}".format(newdir))

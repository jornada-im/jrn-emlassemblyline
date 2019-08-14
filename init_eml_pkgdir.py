# init_eml_pkgdir.py
#
# This is a python script to create an emlassemblyline package directory in 
# a selected location.

import tkinter as tk
from tkinter import filedialog
import os
import pdb

# 
print("Templating a new EMLassemblyline project")

# Ask for some user input about the project.
lterID = input('\nPlease enter the LTER site code (3 letters) : ')
pkg_scope = 'knb-lter-' + lterID

pkgID = input('\nPlease enter the package ID (9 digit number): ')

pkg_shname = input('\nEnter a short package name to append to directory name: ')

pkg_dirname = pkgID + '_' + pkg_shname

# Ask for a location to create the new package directory
root = tk.Tk()
root.wm_withdraw()

print("\nPlease select a location for {0}".format(pkg_dirname))
file_path = filedialog.askdirectory(initialdir=os.getcwd(),
    title='Please select a location'.format(pkg_dirname))

root.update()

# Create package directory
newdir = os.path.join(file_path, pkg_dirname)
if not os.path.exists(newdir):
    os.makedirs(newdir)

print("\n....Created {0}".format(newdir))

# Lay out the contents of the package directory
if not os.path.exists(os.path.join(newdir, 'eml')):
    os.makedirs(os.path.join(newdir, 'eml'))
if not os.path.exists(os.path.join(newdir, 'data_entities')):
    os.makedirs(os.path.join(newdir, 'data_entities'))
if not os.path.exists(os.path.join(newdir, 'metadata_templates')):
    os.makedirs(os.path.join(newdir, 'metadata_templates'))

from shutil import copyfile

copyfile('./pkg210000000_template/README.md', 
    os.path.join(newdir, 'README.md'))
copyfile('./pkg210000000_template/build_210000000.R', 
    os.path.join(newdir, 'build_{0}.R'.format(pkgID)))
copyfile('./pkg210000000_template/metadata_templates/intellectual_rights.txt',
    os.path.join(newdir, 'metadata_templates', 'intellectual_rights.txt'))



# Get info about the eml and data in the package
import requests
import xml.etree.ElementTree as ET
import re

# Find number of most recent revision on EDI
params = (
    ('filter', 'newest'),
#    ('environment', 'production')
)

response = requests.get('https://pasta.lternet.edu/package/eml/{0}/{1}'.format(pkg_scope, pkgID), params=params)

pkg_EDInewrev = response.text

# This is the current EML from EDI, fetch and print to file
response = requests.get('https://pasta.lternet.edu/package/metadata/eml/{0}/{1}/newest'.format(pkg_scope, pkgID))
fname_EDIxml = os.path.join(newdir, 
    '{0}.{1}_EDI.xml'.format(pkgID, pkg_EDInewrev))
# This doesn't seem to work well (namespace problem, registering may help)
#ET.register_namespace('', "http://ecoinformatics.org/eml-2.1.1")
#ET.register_namespace('', "http://www.topografix.com/GPX/1/0")
#root = ET.fromstring(response.text)
#tree = ET.ElementTree(root)
#tree.write(fname_EDIxml)

# Simpler write operation that preserves about everything
with open(fname_EDIxml, 'w') as f:
    f.write(response.text)


# Now get the data entities. First request a list:
response = requests.get('https://pasta.lternet.edu/package/name/eml/{0}/{1}/{2}'.format(pkg_scope, pkgID, pkg_EDInewrev))
# Parse by entity (\n) and ignore empty final list member
data_entities = response.text.split('\n')[0:-1]
# Loop through and get the entity id, request from API, parse header for
# filename, then write it out.
for i in data_entities:
    entid = i.split(',')[0]
    response = requests.get('https://pasta.lternet.edu/package/data/eml/{0}/{1}/{2}/{3}'.format(pkg_scope, pkgID, pkg_EDInewrev, entid))
    d = response.headers['content-disposition']
    fname = re.findall("filename=(.+)", d)[0]
    fnameEDI = fname.split('.')[0] + '_EDI.' + fname.split('.')[1]
    local_fname = os.path.join(newdir, fnameEDI)
    with open(local_fname, 'wb') as f:
        f.write(response.content)

# Probably the most efficient thing is to get the whole 'newest' package:
#response = requests.get('https://pasta.lternet.edu/package/eml/{0}/{1}/newest'.format(pkg_scope, pkgID))
# Split into list
#rlist = response.text.split('\n')

# Item 0 is the data entity, but this could be a list...

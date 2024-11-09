#! python3
import os
import os.path
import zipfile
import shutil

# simple script to extract textures from minecraft mods jar files

dirpath = os.getcwd()
path = ''
for filename in os.listdir(dirpath):
    if filename.endswith('.jar'):
        zf = zipfile.ZipFile(os.path.join(dirpath, filename), "r")
        info = zf.infolist()
        for fn in info:
            if 'assets/' in fn.filename:
                path = zf.extract(fn, dirpath)
        zf.close()
print('Assets extracted to: '+path)

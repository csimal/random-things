#! python3
import os
import os.path

# simple file renaming script

for dirpath, dirnames, filenames in os.walk("."):
    for filename in filenames:
        string = filename

        if string.startswith('dazuli'):
            string = string.replace('dazuli', 'daizuli')

        
        
        if filename != string:
            print(filename + " -> " + string)
            os.rename(os.path.join(dirpath, filename), os.path.join(dirpath, string))

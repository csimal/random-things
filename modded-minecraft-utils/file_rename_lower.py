#! python3
import os
import os.path

# simple file renaming script

for dirpath, dirnames, filenames in os.walk("."):
    for filename in filenames:
        string = filename
        s = ''

        for i,c in enumerate(string):
            if c.isupper():
                if i == 0:
                    s = string[0].lower()
                else:
                    s = s+ c.lower()
            else:
                s = s + c

        string = s

        
        if filename != string:
            print(filename + " -> " + string)
            os.rename(os.path.join(dirpath, filename), os.path.join(dirpath, string))

import re
from shutil import copyfile

"""
    This script scan the shelf file of maya 2017 and strips
    out a list of commands not allowed in Maya 2014 etc.
    Generating shelf files effectively compatible with all maya versions
"""

source_file = './maya2017/shelf_My_awsome_plugin_for_maya.mel'
output_name = 'MASTER_shelf_My_awsome_plugin_for_maya.mel'

# -----------------------------------------------------------------------------

# List of forbidden regexpr patterns
pattern_list  = ['\-highlightColor.*',
                 '\-rotation.*',
                 '\-flipX.*',
                 '\-flipY.*',
                 '\-useAlpha.*',
                 '\-style.*']
                 
# -----------------------------------------------------------------------------

def strip_separators(lines):
    # Iterate each line    
    new_lines = []
    i = 0
    while i < len(lines):
        if re.search('separator', lines[i]):
            i += 1
            while not re.search(';', lines[i]):
                i += 1
            i += 1
        new_lines.append(lines[i])
        i += 1            
    
    return new_lines
    
# -----------------------------------------------------------------------------

def strip_flags(lines, pattern_list):
    new_lines = []
    # Iterate each line
    for line in lines:
        # Regex applied to each line
        valid = True
        for pattern in pattern_list:
            match = re.search(pattern, line)
            if match:
                matched_line = match.group()
                print('Ignore line: '+ matched_line)
                valid = False
                break
        # End for each pattern
        if valid:
            #print( "Valid: "+line )
            new_lines.append(line)
    # End each line
    return new_lines
    
# -----------------------------------------------------------------------------


def write_out(output_name, lines):
    with open(output_name, 'w') as f:
        # go to start of file
        f.seek(0)
        # actually write the lines
        f.writelines(lines)
        
# -----------------------------------------------------------------------------
        
# Make sure file gets closed after being iterated
with open(source_file, 'r') as f:
   # Read the file contents and generate a list with each line
   lines = f.readlines()
   
new_lines = strip_flags(lines, pattern_list)

maya2014_lines = strip_separators(new_lines)

# Maya 2014
write_out("./maya2014/shelf_My_awsome_plugin_for_maya.mel", maya2014_lines)

# Maya 2015
write_out("./maya2015/shelf_My_awsome_plugin_for_maya.mel", new_lines)

# Maya 2016
write_out("./maya2016/shelf_My_awsome_plugin_for_maya.mel", new_lines)

# Maya 2016.5
write_out("./maya2016.5/shelf_My_awsome_plugin_for_maya.mel", new_lines)

# Maya 2017
# Do nothing

# Maya 2018 
copyfile("./maya2017/shelf_My_awsome_plugin_for_maya.mel", "./maya2018/shelf_My_awsome_plugin_for_maya.mel")
        
# -----------------------------------------------------------------------------
     
wait = input("Press ENTER to continue.")
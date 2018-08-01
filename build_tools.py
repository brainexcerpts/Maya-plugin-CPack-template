import sys
import subprocess
import os

# -----------------------------------------------------------------------------

## @param cmd : raw string representing a bat or bash command OR
## a list containing the command name first and then arguments
##
## Notice you can call several commands at a time with "&" 
## very useful to save the context (every time you call call_command the context is lost otherwise)
## Ex: call_command(["call", path_to_script.bat, "&"] + another_command list + ["&", "make", "-j8"])
def call_command(cmd):
    print("\nRUN", cmd)
    ret_code = subprocess.check_call(cmd, shell=True)
    if (ret_code != 0):
        print("cmake failed")
        sys.exit()
    print("\n")
    
# -----------------------------------------------------------------------------

def call_bat_script(file_path):
    call_command(["call", file_path])

# -----------------------------------------------------------------------------

def remove_file(path):
    if os.path.exists(path):
        os.remove(path)


# -----------------------------------------------------------------------------

def make_dir(path_name):
    if not os.path.exists(path_name):
        os.makedirs(path_name)


# -----------------------------------------------------------------------------

## @return true for input 'y' false otherwise
def ask_yes_no(msge):
    while True:
        res = input(msge + " [y/n] : ")
        if (res in ['y', 'n']):
            break
        else:
            print("Please input \'y\' or \'n\'")

    return (res == 'y')


# -----------------------------------------------------------------------------

## @return the index chose by the user in choice_list
## choice_list[user_index]
def ask_choice(msge, choice_list):
    string = ""
    for idx, val in enumerate(choice_list):
        string = string + str(idx + 1) + ") " + str(val) + "\n"

    while True:
        res = int(input(msge + " : \n" + string + ": "))
        if (res > 0 and res <= len(choice_list)):
            break
        else:
            print("\nPlease input a number ranging from [1, " + str(len(choice_list)) + "]")
    res = res - 1
    print("You choose: " + str(choice_list[res]) + "\n")
    return res

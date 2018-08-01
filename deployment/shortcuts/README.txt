List of shortcuts to launch a specific Maya version with our plugin loaded

We use a batch script launch.bat that look up its own location to detect where our plugin is installed, 
setup the environment variables and launch the desired Maya version.

The list of shortcuts are just shorcuts to launch.bat with the proper arguments.

A windows shortcut can't use relative paths unless we use the trick below:
%COMSPEC% /C start /d Contents\ launch.bat 2014

%COMSPEC% is the path to cmd.exe /C indicates we close the command window once finished.
then we start the launch.bat with the argument 2014 meaning Maya 2014
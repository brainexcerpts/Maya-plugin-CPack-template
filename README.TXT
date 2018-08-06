/** */
/**
@page my_awesome_plugin_for_maya Main title

------------
Introduction
------------

This project demonstrate how to automatically pack and distribute a Maya plugin with CMake and CPack.
The plugin files (.mel .mll icons etc.) are first gathered then a zip archive or a windows installer is generated (using NSIS).

The zip files will provide shortcuts to launch maya and automatically load the plugin.
The windows Installer will make sure Maya is aware of the newly installed plugin so that it is available at the next launch of Maya.

------------------------------------------
Generate packages (zip/windows installer)
------------------------------------------

This template project contains the files usually present in a Maya plugin (to be replaced by your own files):
 - /scripts/ contains your mel/python scripts 
 - /prefs/ stores shelves and icons
 - /lib/mayaxxxx/ the plugin executable (.mll)
 - /doc/ user documentation

In order to automaticaly gather all those files and generate zip/windows installer in /build/packages/ simply launch:

	# run_deploy.py

(You will need python3, CMake and NSIS installed)

---------------
Implementation
---------------

We use CMake and CPack to generate zip and windows installer from the plugin files. In the /deployement folder 
you'll find: 

- CMakeLists.txt : dummy cmake in order to run CPack and the generation of the documenation with Doxygen
- cpack_setup.cmake : general CPack definitions to generate the zip file
- cpack_setup_nsis.cmake: specific CPack definitions to generate the NSIS installer
- doxygen_setup.cmake : CMake instruction to autogenerate the documentation with Doxygen

run_deploy.py simply runs cmake with the /deployement/CMakeLists.txt file. 

---------------
NSIS installer
---------------

The generated windows installer is simply a slightly advanced self-extracting executable.
It will self-extract plugin files under: 

	C:\ProgramData\Autodesk\ApplicationPlugins\plugin_name\

Maya will automatically detect the new folder and will know how to load the plugin thanks to the PackageContents.xml file.
*/

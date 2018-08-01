#-------------------------------------------------------------------------------
# NSIS Specific setups
#-------------------------------------------------------------------------------

# Note: Special characters in NSIS variables
# CMAKE_NSIS variables are ultimately expanded into NSIS configuration files
# for a backslash, quote etc to expand correctly into the nsis files you
# should use the following:
# (backslash) \ -> \\\\
# (quote)     " -> \\\"
#
# You can use some built in variables defined in NSIS documentation
# such as: $PROFILE, $INSTDIR etc.

# This set the default installation path to:
# C:/Program Files/
#set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")

set(CPACK_PACKAGE_INSTALL_DIRECTORY "${MAYA_PLUGIN_BIN_NAME}")
set(CPACK_NSIS_DISPLAY_NAME ${CPACK_PACKAGE_NAME})
set(CPACK_NSIS_PACKAGE_NAME ${CPACK_PACKAGE_NAME})

set(CPACK_NSIS_EXECUTABLES_DIRECTORY "plugin")
# This set the default installation path to:
# c/:user/documents/maya/2016/
#set(CPACK_NSIS_INSTALL_ROOT "$PROFILE\\\\documents\\\\maya\\\\2016")

# This set the default installation path to:
# C:/ProgramData/Autodesk/ApplicationPlugins/
set(CPACK_NSIS_INSTALL_ROOT "$APPDATA\\\\Autodesk\\\\ApplicationPlugins")

# Force the component core maya_ver to be installed in:
# C:/ProgramData/Autodesk/ApplicationPlugins/
set(CPACK_NSIS_CORE_INSTALL_DIRECTORY "$APPDATA\\\\Autodesk\\\\ApplicationPlugins")

# We force the installation path of the following components as well:
foreach(MVER ${MAYA_LIST_VERSIONS})
    set(CPACK_NSIS_MAYA${MVER}_INSTALL_DIRECTORY "$APPDATA\\\\Autodesk\\\\ApplicationPlugins")
endforeach(MVER ${MAYA_LIST_VERSIONS})

#set(CPACK_NSIS_USER_MANUAL_DIRECTORY "$APPDATA\\\\Autodesk\\\\ApplicationPlugins")
#set(CPACK_NSIS_VIDEOS_DIRECTORY "$APPDATA\\\\Autodesk\\\\ApplicationPlugins")

# --------------------------------------------------------------------------
# ICONS

set(ICON_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../deployment/resources")

# icon for the generated install program
set(CPACK_NSIS_MUI_ICON    "${ICON_PATH}/application.ico")

# icon for the generated uninstall program
set(CPACK_NSIS_MUI_UNIICON "${ICON_PATH}/application.ico")

# NSIS define does not support forward slashes,
# We replace them by backslashes
string(REGEX REPLACE "/" "\\\\\\\\" ICON_PATH_NSIS ${ICON_PATH})
# set NSIS welcome icon:
# recommended size: 164x314 (bmp format "Do not write color space information") 24bit.
# The recommended size does not work for me, use: 191x290
# set NSIS banner icon:
# recommended size: 150x57 (I use 175x53 and it seems to work best)

# when using
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE
    "!define MUI_WELCOMEFINISHPAGE_BITMAP \\\"${ICON_PATH_NSIS}\\\\welcome.bmp\\\"
     !define MUI_HEADERIMAGE_BITMAP       \\\"${ICON_PATH_NSIS}\\\\header.bmp\\\"
     !define MUI_ICON                     \\\"${ICON_PATH_NSIS}\\\\application.ico\\\"
     !define MUI_UNICON                   \\\"${ICON_PATH_NSIS}\\\\application.ico\\\"")

# set icon in windows "add/remove program"
set(CPACK_NSIS_INSTALLED_ICON_NAME "Uninstall.exe")

# --------------------------------------------------------------------------
# start menu shorcuts
set(CPACK_NSIS_CREATE_ICONS_EXTRA
    "CreateShortcut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\documentation.lnk\\\" \\\"$INSTDIR\\\\documentation\\\\user_documentation.htm\\\"
    CreateShortcut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\plugin.lnk\\\" \\\"$INSTDIR\\\"" )
set(CPACK_NSIS_DELETE_ICONS_EXTRA
    "Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\documentation.lnk\\\"
    Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\plugin.lnk\\\"" )

# This will do the job same as the above lines: (but I wasn't able to create folder shortcut this way)
# set(CPACK_NSIS_MENU_LINKS "documentation\\\\user_documentation.htm" "documentation")
#set(CPACK_NSIS_MENU_LINKS "maya_with_SWE.bat" "start_with_SWE")

set(CPACK_NSIS_CONTACT ${CPACK_PACKAGE_CONTACT})

# Ask about uninstalling previous versions first.
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)

# when ON add a page to ask user if the application should be added to PATH
set(CPACK_NSIS_MODIFY_PATH OFF)

# call the batch file: $INSTDIR\plugin\install.cmd $INSTDIR\plugin
#set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\plugin\\\\install.cmd\\\" \\\"$INSTDIR\\\\plugin\\\"'" )
# call the batch file: $INSTDIR\plugin\uninstall.cmd $INSTDIR\plugin
#set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\plugin\\\\uninstall.cmd\\\" \\\"$INSTDIR\\\\plugin\\\"'" )


# todo : open folder at the end of installation
# ExecShell "open" "$PLUGINSDIR\source"

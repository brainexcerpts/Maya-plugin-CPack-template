# ------------------------------------------------------------------------------

set(ENABLE_COMPONENT_VIDEOS "0")

# ------------------------------------------------------------------------------

if( (CPACK_GENERATOR STREQUAL "NSIS") OR (CPACK_GENERATOR STREQUAL "NSIS64"))
    set(IS_NSIS_ENABLED 1)
else()
    set(IS_NSIS_ENABLED 0)
endif()

# ------------------------------------------------------------------------------

if( ${MAYA_VERSION} STREQUAL "All" )
    set(MAYA_VERSION "_every-versions")
    set(MAYA_LIST_VERSIONS "2014" "2015" "2016" "2016.5" "2017" "2018")
else()
    set(MAYA_LIST_VERSIONS ${MAYA_VERSION})
endif()

# ------------------------------------------------------------------------------
# Set Version number == (MAJOR.MINOR.PATCH)

include( "${CMAKE_CURRENT_SOURCE_DIR}/version_number.cmake" )
set(CPACK_PACKAGE_VERSION_MAJOR ${project_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${project_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${project_VERSION_PATCH})


# ------------------------------------------------------------------------------

set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
SET(CPACK_OUTPUT_FILE_PREFIX "../packages")

# Info
set(CPACK_PACKAGE_NAME "my-awesome-plugin-for-maya${MAYA_VERSION}") # <- only use lower case characters and dashes instead of blank spaces
set(CPACK_PACKAGE_VENDOR "My Awesome Company")
set(CPACK_PACKAGE_CONTACT "my.email@free.com") # <- not sure it's an official cpack variable though
set(CPACK_PACKAGE_URL "my.email@free.com") # <- not sure it's an official cpack variable though
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Skinning weight editor for Maya")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")

if(build_type STREQUAL "debug")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_FILE_NAME}_debug")
endif()

set(RESOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../deployment/resources)

set(CPACK_RESOURCE_FILE_README  "${CMAKE_CURRENT_SOURCE_DIR}/../README.txt")
set(CPACK_RESOURCE_FILE_LICENSE "${RESOURCE_DIR}/LICENSE.txt")
set(CPACK_RESOURCE_FILE_WELCOME "${RESOURCE_DIR}/WELCOME.txt")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${RESOURCE_DIR}/DESCRIPTION.txt")
if( NOT ${IS_NSIS_ENABLED} )
    # This raises a NSIS compilation error (and is not necessary for NSIS anyways)
    set(CPACK_PACKAGE_ICON "${RESOURCE_DIR}/application.ico")
endif()

# note:
# We can define each component description's text by setting variables of the form
# CPACK_COMPONENT_XXXX_DISPLAY_NAME
# CPACK_COMPONENT_XXXX_DESCRIPTION

#-------------------------------------------------------------------------------
# Export "plugin" module

# when required cannot be unchecked at package installation
set(CPACK_COMPONENT_CORE_REQUIRED TRUE)
install(FILES "${PROJECT_BINARY_DIR}/PackageContents.xml" DESTINATION "/" COMPONENT "Core")
if( NOT ${IS_NSIS_ENABLED} )
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/shortcuts/launch.bat" DESTINATION "Contents/" COMPONENT "Core")
endif()

install(FILES ${RESOURCE_DIR}/LICENSE.txt DESTINATION "/" COMPONENT "Core")

foreach(MVER ${MAYA_LIST_VERSIONS})
    #set(CPACK_COMPONENT_MAYA${MVER}_REQUIRED TRUE) # when required cannot be unchecked at package installation
    set(CPACK_COMPONENT_MAYA${MVER}_DISPLAY_NAME "Plugin for Maya ${MVER}")
    set(CPACK_COMPONENT_MAYA${MVER}_DESCRIPTION "Plugin files (mll, icons, mel scripts etc.)")

    if( NOT ${IS_NSIS_ENABLED} )
        # For the zip file package we provide shortcuts to launch maya and our plugin:
        install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/shortcuts/launch_maya_${MVER}.lnk DESTINATION "/" COMPONENT "maya${MVER}")
    endif()

    #install(TARGETS  ${PROJECT_NAME} RUNTIME DESTINATION "maya${MVER}/plug-ins" COMPONENT "plugin")
    install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../lib/maya${MVER}/release/${MAYA_PLUGIN_BIN_NAME}.mll DESTINATION "Contents/${MVER}/plug-ins" COMPONENT "maya${MVER}")

    file(GLOB script_files
        ${CMAKE_CURRENT_SOURCE_DIR}/../scripts/*.mel
        )

    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../scripts/${PROJECT_NAME}_load.mel)
        # This script name must be ${PROJECT_NAME}_load.mel for maya to automatically execute it.
        message(FATAL_ERROR "The script file ${CMAKE_CURRENT_SOURCE_DIR}/../scripts/${PROJECT_NAME}_load.mel is missing")
    endif()

    install(FILES ${script_files} DESTINATION "Contents/${MVER}/scripts" COMPONENT "maya${MVER}")

    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../prefs/icons DESTINATION "Contents/${MVER}/prefs" COMPONENT "maya${MVER}")

    file(GLOB shelves_files ${CMAKE_CURRENT_SOURCE_DIR}/../prefs/shelves/maya${MVER}/*.mel )
    install(FILES ${shelves_files} DESTINATION "Contents/${MVER}/prefs/shelves" COMPONENT "maya${MVER}")

    # batch files for installation/ uninstallation
    #install(FILES     ${RESOURCE_DIR}/install.cmd     DESTINATION "Contents/${MVER}/" COMPONENT "maya${MVER}")
    #install(FILES     ${RESOURCE_DIR}/uninstall.cmd   DESTINATION "Contents/${MVER}/" COMPONENT "maya${MVER}")
endforeach(MVER ${MAYA_LIST_VERSIONS})

#-------------------------------------------------------------------------------
# Export "samples" module

set(CPACK_COMPONENT_SAMPLES_DISPLAY_NAME "Sample Models")
set(CPACK_COMPONENT_SAMPLES_DESCRIPTION "Pre-rigged Maya models.")

foreach(MVER ${MAYA_LIST_VERSIONS})
    file(GLOB sample_files
        ${CMAKE_CURRENT_SOURCE_DIR}/../samples/maya${MVER}/*.mb        
        )
    install(FILES ${sample_files} DESTINATION "samples" COMPONENT "samples")
endforeach(MVER ${MAYA_LIST_VERSIONS})
#-------------------------------------------------------------------------------
# Export "user_manual" module

set(PACKAGE_HELP_FILE "user_documentation.htm")
set(PACKAGE_DOC_PATH "documentation")

set(CPACK_COMPONENT_USER_MANUAL_DISPLAY_NAME "User Documentation")
set(CPACK_COMPONENT_USER_MANUAL_DESCRIPTION "Html user documentation.")
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/html                   DESTINATION ${PACKAGE_DOC_PATH} COMPONENT "user_manual")
install(FILES     ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/${PACKAGE_HELP_FILE}   DESTINATION ${PACKAGE_DOC_PATH} COMPONENT "user_manual")

#-------------------------------------------------------------------------------
# Export "videos" module
if( ENABLE_COMPONENT_VIDEOS )
    set(CPACK_COMPONENT_VIDEOS_DISPLAY_NAME "Video tutorials")
    set(CPACK_COMPONENT_VIDEOS_DESCRIPTION "Tutorials in videos")
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/videos DESTINATION ${PACKAGE_DOC_PATH} COMPONENT "videos")
endif()

#-------------------------------------------------------------------------------
# Generate PackageContents.xml

configure_file (
  "${PROJECT_SOURCE_DIR}/PackageContents.xml.in"
  "${PROJECT_BINARY_DIR}/PackageContents.xml"
  )

#-------------------------------------------------------------------------------

if( ${IS_NSIS_ENABLED} )
    include(${CMAKE_CURRENT_SOURCE_DIR}/cpack_setup_nsis.cmake)
endif()

include(CPack)

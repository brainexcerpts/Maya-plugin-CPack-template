find_package(Doxygen)

if (NOT DOXYGEN_FOUND)
    message(WARNING "Doxygen is needed to build the documentation.")
else()
    # this will run doxygen at compilation time
    add_custom_target(
        user_documentation ALL
        ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/doxygen_config.txt
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual
     )

    # Copy needed image files (doxygen might not do it himself if the @image tag
    # is not used in .dox files, and sometimes I use raw html code...)
    file(GLOB_RECURSE images
        ${CMAKE_CURRENT_SOURCE_DIR}/../prefs/icons/*.png
        ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/images/*.png
        )
    add_custom_command(
         TARGET user_documentation POST_BUILD
         COMMAND ${CMAKE_COMMAND} -E copy
                 ${images}
                 ${CMAKE_CURRENT_SOURCE_DIR}/../doc/manual/html
                 )
endif()

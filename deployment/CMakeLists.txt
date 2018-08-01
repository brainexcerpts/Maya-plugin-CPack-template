
# ------------------------------------------------------------------------------
# Dummy setup for cmake to work properly
cmake_minimum_required(VERSION 3.4)
project(my_awesome_plugin_for_maya)
set(MAYA_PLUGIN_BIN_NAME "${PROJECT_NAME}")
add_library( ${PROJECT_NAME} STATIC main.cpp)
target_link_libraries( ${PROJECT_NAME} )

include(${CMAKE_CURRENT_SOURCE_DIR}/cpack_setup.cmake)

include(${CMAKE_CURRENT_SOURCE_DIR}/doxygen_setup.cmake)

# ------------------------------------------------------------------------------

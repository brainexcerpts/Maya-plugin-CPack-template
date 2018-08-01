import os
import traceback

import sys
from build_tools import *



# -----------------------------------------------------------------------------

def main():
    try:
        deploy_directory = "build/deploy"
        make_dir(deploy_directory)
        os.chdir(deploy_directory)

        maya_version_list = ["All", "2014", "2015", "2016", "2016.5", "2017", "2018"]
        selected_version = ask_choice("Choose Maya version", maya_version_list)

        maya_version = str(maya_version_list[selected_version])        

        remove_file("CMakeCache.txt")
        cmake_cmd = ["cmake",
                     "-D", "CPACK_GENERATOR=ZIP",
                     "-G", "MinGW Makefiles",
                     "-D", "MAYA_VERSION=" + maya_version,                     
                     "../../deployment"]
        call_command(cmake_cmd)
        call_command(["mingw32-make", "user_documentation"])
        call_command(["cpack"])

        # Re-run for NSIS
        # remove_file("CMakeCache.txt")
        cmake_cmd[2] = "CPACK_GENERATOR=NSIS64"
        call_command(cmake_cmd)
        call_command(["cpack"])

    except Exception as err:
        print("Exception raised")
        print(err)
        print("Trace: ")
        print(traceback.print_exc())
    finally:
        wait = input("Press ENTER to continue.")


# -----------------------------------------------------------------------------	

if __name__ == "__main__":
    main()

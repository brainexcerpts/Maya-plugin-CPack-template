#!/bin/bash

doxygen doxygen_config.txt 2> dox_error.log
cp ../../prefs/icons/*.png ./html/.
cp ./images/*.png ./html/.

echo ""
echo "===================="
read -r -p "Stroke enter to exit " response
exit
#!/bin/bash
function print_usage()
{	
    echo "Usage: OUT_DIR=<out-dir> ./start-quicktype.sh"	
}	

if [[ -z "${OUT_DIR}" ]]; then	
    echo "Error: Environment variable OUT_DIR not defined."	
    print_usage	
    exit 0	
fi	

docker run -it --rm -v ${OUT_DIR}:/code spirent-jq bash
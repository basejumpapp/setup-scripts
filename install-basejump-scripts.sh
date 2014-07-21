#!/bin/bash
set -e

LOCATION="/usr/local/bin"

echo "Installing ${LOCATION}/grant-basejump-access.sh and ${LOCATION}/remove-basejump-access.sh."
echo "Please hit Ctrl+C to cancel now."
( set -x; sleep 2 )

function do_install() {
    FILE="${1}"
    FILEPATH="${LOCATION}/${FILE}"
    echo "Downloading and installing $FILE"
    curl -s https://basejumpapp.github.io/setup-scripts/$FILE > ${FILEPATH}
    chmod a+x $FILEPATH
}


do_install remove-basejump-access.sh
do_install grant-basejump-access.sh


# done
echo "Scripts downloaded and installed."

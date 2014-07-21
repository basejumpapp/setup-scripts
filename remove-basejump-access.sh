#!/bin/bash

AUTHORIZED_KEYS_DIR="/root/.ssh"
AUTHORIZED_KEYS="${AUTHORIZED_KEYS_DIR}/authorized_keys"
AUTHORIZED_KEYS_BACKUP="./authorized_keys.orig"
BASEJUMP_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsCN7P6FfrreK/ZeeZxc9YaYPDoYUAUdr4NK/gUzuK3XWEwx5wf8YAp7K0c0ziuMNXaigYwKiAoWGKM89eXZEx5GSKhVHCVOHY85wFn7b1UjTPUcPIwtQfjbfG0fT6blFo046XmilQuMQEyxhRWmpuJ8ogXvYNaPnaglrkPQ/FRr98QlMNn4YRvhC2mEyTRT+bFlprTiMZz1Y92eV3dN1vEzGav6c048pXcldCRjqYboT5Qzq5NTKMwKGRPwFsbvpKwdYtSm7bMAa5pnRfCGtulUDuoDdnotRRO60f9rHaIS+j25q3dO8sNGnhUkzzC6j1UoDA7Q39KSbi7dTFwVu5 basejump@basejumpit.com"


# explain and check before proceeding
read -r -p "This script will remove ssh access granted to the basejump installer.  It will modify the file ${AUTHORIZED_KEYS}.  Do you wish to proceed? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
        echo "Ok. Will do."
        ;;
    *)
        echo "Exiting."
        exit 1
        ;;
esac

# check for authorized_keys file
if [ ! -e $AUTHORIZED_KEYS ]; then
    echo "No ${AUTHORIZED_KEYS} file was found so nothing was done."
    echo "Exiting."
    exit 1
fi


# make a backup
cp $AUTHORIZED_KEYS $AUTHORIZED_KEYS_BACKUP

# remove the key
fgrep -v "$BASEJUMP_PUBLIC_KEY" $AUTHORIZED_KEYS_BACKUP >$AUTHORIZED_KEYS

# done
echo "All done. Thanks for using Basejump."

#!/bin/bash

AUTHORIZED_KEYS_DIR="/root/.ssh"
AUTHORIZED_KEYS="${AUTHORIZED_KEYS_DIR}/authorized_keys"
AUTHORIZED_KEYS_BACKUP="./authorized_keys.orig"
BASEJUMP_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsCN7P6FfrreK/ZeeZxc9YaYPDoYUAUdr4NK/gUzuK3XWEwx5wf8YAp7K0c0ziuMNXaigYwKiAoWGKM89eXZEx5GSKhVHCVOHY85wFn7b1UjTPUcPIwtQfjbfG0fT6blFo046XmilQuMQEyxhRWmpuJ8ogXvYNaPnaglrkPQ/FRr98QlMNn4YRvhC2mEyTRT+bFlprTiMZz1Y92eV3dN1vEzGav6c048pXcldCRjqYboT5Qzq5NTKMwKGRPwFsbvpKwdYtSm7bMAa5pnRfCGtulUDuoDdnotRRO60f9rHaIS+j25q3dO8sNGnhUkzzC6j1UoDA7Q39KSbi7dTFwVu5 basejump@basejumpit.com"

# explain and check before proceeding
echo ""
read -r -p "This script will grant ssh access to user root for the basejump installer. It will modify the file at ${AUTHORIZED_KEYS}.  Do you wish to proceed? [y/N] " response
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
    read -r -p "No ${AUTHORIZED_KEYS} file was found.  Should I make one? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            echo "Ok. Making the file."
            mkdir -p $AUTHORIZED_KEYS_DIR
            touch $AUTHORIZED_KEYS
            chmod 600 $AUTHORIZED_KEYS
            echo "Created file $AUTHORIZED_KEYS."
            ;;
        *)
            echo "Exiting."
            exit 1
            ;;
    esac

fi

# make a backup
cp $AUTHORIZED_KEYS $AUTHORIZED_KEYS_BACKUP

# remove it if it already exists
fgrep -v "$BASEJUMP_PUBLIC_KEY" $AUTHORIZED_KEYS_BACKUP >$AUTHORIZED_KEYS

# add it to the end
echo "$BASEJUMP_PUBLIC_KEY" >> $AUTHORIZED_KEYS

# done
echo "All done. Thanks for using Basejump."

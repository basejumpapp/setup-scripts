#!/bin/bash

# explain and check before proceeding
if [ "$1" != "-y" ]; then
    read -r -p "This script will setup this server for Basejump configuration.  Do you wish to proceed? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Exiting."
            exit 1
            ;;
    esac
fi;

# determine OS
if [ -e /etc/redhat-release ]; then
    CENTOS_VERSION=$(cat /etc/redhat-release | grep CentOS)
    if [ -z "$CENTOS_VERSION" ]; then
        echo "Unknown CentOS version found: $CENTOS_VERSION."
        exit 127
    fi
    IS_ALLOWED_VERSION=1
    IS_CENTOS=1
fi
if [ -e /etc/issue ]; then
    cat /etc/issue | grep Amazon
    IS_AMAZON=1
    IS_ALLOWED_VERSION=1
fi

# exit if not a good OS
if [ -z "$IS_ALLOWED_VERSION" ]; then
    echo "This OS is not supported."
    exit 127
fi

# if Centos, make sure EPEL is enabled
if [[ $IS_CENTOS ]]; then
    REPOS=$(yum repolist all | grep epel/x86_64)
    if [ -z "$REPOS" ]; then
        # install EPEL
        rpm -ivh http://mirror.steadfast.net/epel/6/i386/epel-release-6-8.noarch.rpm
        # make it disabled by default
        yum-config-manager --disable epel
    fi
fi

# if docker doesn't exists, install it
docker --version 2>/dev/null
if [ "$?" -ne "0" ]; then
    echo "Docker not found.  Installing docker.";
    if [[ $IS_CENTOS ]]; then
        yum -y --enablerepo=epel-testing install docker-io
    fi;
    if [[ $IS_AMAZON ]]; then
        yum -y install docker
    fi;

    # start docker service
    chkconfig docker on && service docker start
fi;

# make sure rsync is protocol version 31 or greater
PROTOCOL_VERSION=$(rsync --version | head -n 1 | awk '{print $6}')
if [ "$PROTOCOL_VERSION" -lt 31 ]; then
    echo "rsync with protocol version $PROTOCOL_VERSION found.  Upgrading rsync. "
    yum -y install http://pkgs.repoforge.org/rsync/rsync-3.1.1-1.el6.rfx.x86_64.rpm
fi

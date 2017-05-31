#!/bin/sh

set -e

scriptdir=$(cd $(dirname $0);pwd)

backup_file() {
    local target=$1
    if [ -L $target ]; then
        echo "Removing old link: $target"
        rm -f $target
    elif [ -e $target ]; then
        echo "Backing up old file: $target"
        mv $target $target-backup-$(date +%Y-%m-%d-%H:%M)
    fi
}

install_file() {
    local source_file=$1
    local dest_file=$2

    backup_file $2
    echo "Installing new $dest_file"
    ln -s $(readlink -f $source_file) $dest_file
}

for fn in $scriptdir/dotfiles/*
do
    install_file $fn ~/.$(basename $fn)
done

#!/bin/bash

function checkbin() {
    type -P su-exec
}

function su_mt_user() {
    su sipac -c '"$0" "$@"' -- "$@"
}

chown sipac:sipac /home/sipac/android-sdk-linux

printenv

if checkbin; then
    exec su-exec sipac:sipac /opt/tools/android-sdk-update.sh "$@"
else
    su_mt_user /opt/tools/android-sdk-update.sh ${1}
fi








#!/bin/bash

git config --global user.email $GEMAIL
git config --global user.name $GNAME

/usr/sbin/sshd -De
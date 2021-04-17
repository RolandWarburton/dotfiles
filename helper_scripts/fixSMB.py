#!/usr/bin/env python3

# The purpose of this script is to fix an issue that i get with Thunar and SMB shares:
# If the below packages aren't installed
# and the user isn't in the fuse group
# then when you try to open pictures (png, jpg, etc) they would not open at all
# this hopefully fixes that.

# No package installation is required as far as i know
# "apt" should come with the debian install of python i believe
# the rest of the packages are also npyrhon3
import sys
import os
import getpass
import apt


def preFlight(applications):
    errors = []
    cache = apt.Cache()
    cache.open()
    for app in applications:
        try:
            cache[app].is_installed
        except:
            errors.append(f"{app} is not installed.")
    if len(errors) == 0:
        return True
    else:
        for err in errors:
            print(err)
        return False


def main():
    # check required packages are installed
    if not preFlight(["sshfs", "gvfs-backends", "gvfs-common", "gvfs-fuse", "fuse"]):
        print("failed pre flight")
        return False
    else:
        print("passed pre flight")

    # Get array of groups for the whole system
    groups = os.popen("cut -d: -f1 /etc/group | sort").read().split("\n")
    groups = list(filter(None, groups))
    print(groups)

    # get the users groups
    userGroups = os.popen("groups | sort").read().split(" ")
    userGroups = list(filter(None, userGroups))

    # idx is an object that has the interator and the value. IE. (i, val)
    for idx in enumerate(userGroups):
        i = idx[0]
        userGroups[i] = userGroups[i].replace("\n", "")
        userGroups[i] = userGroups[i].replace("\r", "")

    # add the group if it doesn't exist
    if not "fuse" in groups:
        print("fuse group does not exist. Creating it...")
        os.system("sudo groupadd fuse")

    # add the user to the group
    if not "fuse" in userGroups:
        print(
            f"user {getpass.getuser()} is not in the fuse group. Adding them..."
        )
        os.system("sudo usermod -aG fuse roland")
        print("You should reboot to ensure the group changes take effect.")


main()

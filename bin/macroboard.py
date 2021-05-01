#!/usr/bin/env python3

# ! ================================================================
# ! ALSO make sure that "actkbd" is installed,
# ! theres no pre flight check for that because its a root only program
# ! ================================================================

import sys
import os
import apt
import getpass


def question(q): return input(q).lower().strip()[0] == "y" or question(q)


def disableDevice():
    '''
    Disables the razer keyboard i use for macros device with xinput
    '''
    cmd = f"xinput list | grep \"Razer.*.keyboard\" | grep \"id=..\" -o | cut -c 4-"
    devices = list(filter(None, os.popen(cmd).read().split("\n")))
    for id in devices:
        print(f"disabling device {id}")
        cmd = f"xinput --disable {id}"
        os.popen(cmd).read()


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
    if not preFlight(["xinput", "jumpapp"]):
        print("failed pre flight")
        return False
    else:
        print("passed pre flight")

    # disable the keyboard
    disableDevice()

    try:
        if sys.argv[1] == "-y":
            generateConfig = True
    except:
        generateConfig = question("write config to /etc/actkbd ")

    if generateConfig:
        print(f"writing config")
        print(sys.argv[0])
        abspath = os.path.abspath(sys.argv[0])
        pathTemp = os.path.split(abspath)[0]
        path = os.path.join(pathTemp, "../actkbd.conf")
        print(path)
        # cmd = "sudo cp ../actkbd.conf /etc/actkbd.conf"
        # res = os.popen(cmd).read()
        # print(res)


main()

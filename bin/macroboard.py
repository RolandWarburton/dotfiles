#!/usr/bin/env python3

# ! ================================================================
# ! ALSO make sure that "actkbd" is installed,
# ! theres no pre flight check for that because its a root only program
# ! ================================================================

import sys
import os
import apt
import getpass
from pathlib import Path
import subprocess
import time


def question(q): return input(q).lower().strip()[0] == "y" or False


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


# https://stackoverflow.com/questions/36596354/how-to-get-exit-code-from-subprocess-popen/36596554
def execCommand(params):
    # Create a process
    p = subprocess.Popen(params,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT)

    try:
        # Filter stdout
        for line in iter(p.stdout.readline, ''):
            # Get everything out of the buffer and onto the screen
            # When we execute print statements output will be written to buffer (flushed)
            #   and we will see the output on screen when buffer get flushed (cleared).
            #   By default buffer will be flushed when program exits.
            sys.stdout.flush()
            # Print the flushed buffer or whatever i don't really understand how this works
            print(">>> " + line.rstrip())
            sys.stdout.flush()
    except:
        sys.stdout.flush()

    # Wait until process terminates (without using p.wait())
    while p.poll() is None:
        # Process hasn't exited yet, let's wait some
        time.sleep(0.5)

    # Get return code from process
    return_code = p.returncode

    print('RETURN CODE', return_code)


def runSetup():
    # check required packages are installed
    if not preFlight(["xinput", "jumpapp"]):
        print("failed pre flight")
        return False
    else:
        print("passed pre flight")

    # disable the keyboard
    disableDevice()

    # If we passed -y then don't bother asking if we want to generate a config
    generateConfig = False
    if 1 < len(sys.argv) and sys.argv[1] == "-y":
        generateConfig = True
    else:
        if not question("write config to /etc/actkbd "):
            generateConfig = False

    if generateConfig:
        # Write the config
        print("writing config")

        # Am i retarded or is this actually the right way of getting the parent directory?
        actkbdPath = Path(sys.argv[0]).parent.absolute().parent.absolute()

        # Run this command
        # cmd = f"sudo cp {actkbdPath}/actkbd.conf /etc/actkbd.conf"
        cmd = ["sudo", "cp", f"{actkbdPath}/actkbd.conf", "/etc/actkbd.conf"]
        execCommand(cmd)


def main():
    runSetup()


main()

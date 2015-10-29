#!/usr/bin/env python
####################################################################################################
#
# ABOUT
#
#   My attempt to creat a ping script
#
####################################################################################################
#
# HISTORY
#
#   Version 1.0
#
####################################################################################################

import sys
import subprocess

cmdping = "ping -c4 COMPUTERNAME"
p = subprocess.Popen(cmdping, shell=True, stderr=subprocess.PIPE)
while True:
    out = p.stderr.read(1)
    if out == '' and p.poll() != None:
        break
    if out != '':
        sys.stdout.write(out)
        sys.stdout.flush()

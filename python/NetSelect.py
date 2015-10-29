#!/usr/bin/env python
####################################################################################################
#
# ABOUT
#
#   This script was written on the fly for no particular reason It was mostly
#   to see if I could write soemthing with all that I had learned from a Python
#   class. I mostly keep it around out of pride even though it is a terrible
#   script.
#
####################################################################################################
#
# HISTORY
#
#   Version 1.0
#
####################################################################################################

import subprocess

loc = "scselect"
srn = "scselect WORK"
home = "scselect HOME"

a = subprocess.check_output(loc, shell=True)

print "\n################# NETWORK SELECTION ####################"
print "\nYour current location is set to \n\n%s" % a
print "########################################################"

choice = raw_input("Please select what location you want to change to: ")
print "########################################################"

choice = int(choice)

if choice == 1:
        print "\nSwitching to HOME...\n"
        output1 = subprocess.check_output(home, shell=True)
        print output1
        print "########################################################"

elif choice == 2:
        print "\nSwitching to WORK...\n"
        output2 = subprocess.check_output(srn, shell=True)
        print output2
        print "########################################################"

else:
        print "\nInvalid selection. Shutting down...\n"
        print "########################################################"

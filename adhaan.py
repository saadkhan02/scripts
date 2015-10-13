#!/usr/bin/python3

# This script plays the adhaan from a list of audio files according to salaah
# times mentioned in the table.

import subprocess
import time
import re
import os

path = os.path.dirname(os.path.realpath(__file__))
salaahTimes = {
    "fajr":"",
    "dhuhur":"",
    "asr":"",
    "maghrib":"",
    "isha":""
}

AUDIO_PROGRAM = "/usr/bin/cvlc"
ADHAAN_FILE = path + "/helperFiles/adhaan.mp3"
FAJR_ADHAAN_FILE = path + "/helperFiles/fajrAdhaan.mp3"
CALENDAR = path + "/helperFiles/calendar"

##
# Plays the adhaan using the default media player. Plays the fajr adhaan at
# fajr time and regular adhaan otherwise.
#
# @param salaah Name of salaah to be prayed next.
#
def playAdhaan(salaah):
    if (salaah == "fajr"):
        adhaanFile = FAJR_ADHAAN_FILE
    else:
        adhaanFile = ADHAAN_FILE

    subprocess.call([AUDIO_PROGRAM, adhaanFile, "--play-and-exit"])

##
# Finds out salaah times for today.
#
def getSalaahTimes():
    dayOfMonth = time.strftime("%m%d")

    cal = open(CALENDAR)
    content = cal.read()
    cal.closed
    lines = re.split(r"\n", content)
    for line in lines:
        elements = re.split(r"\s", line)
        if (dayOfMonth == elements[0]):
            salaahTimes["fajr"] = elements[2]
            salaahTimes["dhuhur"] = elements[4]
            salaahTimes["asr"] = elements[5]
            salaahTimes["maghrib"] = elements[6]
            salaahTimes["isha"] = elements[7]

##
# Main function.
#
def main():
    getSalaahTimes()
    while (True):
        currentTime = time.strftime("%H:%M")
        if (currentTime == salaahTimes["fajr"]):
            playAdhaan("fajr")
        elif (currentTime == salaahTimes["dhuhur"] or
              currentTime == salaahTimes["asr"] or
              currentTime == salaahTimes["maghrib"] or
              currentTime == salaahTimes["isha"]):
            # The argument "regular" doesn't do much but reads better.
            playAdhaan("regular")
        elif (currentTime == "00:01"):
            getSalaahTimes()

        # Sleep for some time.
        time.sleep(55)

main()

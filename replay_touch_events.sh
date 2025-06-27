#!/bin/bash

echo "Looking for touchscreen device..."
TOUCH_DEVICE=`./find_touchscreen_name.sh`

echo "$TOUCH_DEVICE"

# Check if the file `mysendevent` exists in the phone

ABI=`adb shell getprop ro.product.cpu.abi`
EXE=mysendevent
if [[ "$ABI" -eq "arm64-v8a" ]]; then
    EXE=mysendevent-arm64
fi

EVENT_DIR=/sdcard/Download

MYSENDEVENT=`adb shell ls /data/local/tmp/$EXE 2>&1`
echo ---"$MYSENDEVENT"---
[[ "$MYSENDEVENT" == *"No such file or directory"* ]] && adb push $EXE /data/local/tmp/

adb push recorded_touch_events.txt $EVENT_DIR

# Replay the recorded events
adb shell su -c /data/local/tmp/$EXE "${TOUCH_DEVICE#*-> }" $EVENT_DIR/recorded_touch_events.txt

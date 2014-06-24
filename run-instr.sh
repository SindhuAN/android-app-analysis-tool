#!/bin/bash
#this is a script for running soot
ANDROID_JARS_DIR=/home/dgen/android/android-platforms-master
#you should modify the path in which you store the apks
APPS_DIR=/home/dgen/mobileApps/results
#soot output 
SOOT_OUTPUT_DIR=/home/dgen/android-instrumentation/soot-output
KEYSTORE_DIR=~/.android


if [ $# -lt 1 ]; then
        echo "Usage: $0 run-instr.sh name-of-app."
        exit 1
fi

javac AndroidInstrument.java
java -Xmx900m AndroidInstrument  -d $SOOT_OUTPUT_DIR -w -android-jars $ANDROID_JARS_DIR  -allow-phantom-refs   -process-dir $APPS_DIR/$1.apk 
#at this moment there is no need to install
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore $KEYSTORE_DIR/debug.keystore  $SOOT_OUTPUT_DIR/$1.apk androiddebugkey -storepass android
#adb -d install $SOOT_OUTPUT_DIR/$1.apk
adb -s emulator-5554 -d install $SOOT_OUTPUT_DIR/$1.apk
rm $SOOT_OUTPUT_DIR/$1.apk
cp static-analysis.txt static-analysis.$1.txt
rm static-analysis.txt


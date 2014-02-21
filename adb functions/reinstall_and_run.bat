adb uninstall com.lazaknitez
adb install ..\export\android\bin\bin\LAZAKNITEZ-debug.apk
adb shell am start -n com.lazaknitez/.MainActivity
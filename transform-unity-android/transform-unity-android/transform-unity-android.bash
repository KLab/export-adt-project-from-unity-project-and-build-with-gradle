#!/usr/bin/env bash -ex

# ADT directories
#
# build-adt
# └── Product Name
#     ├── assets
#     │   └── …
#     ├── libs
#     │   └── …
#     ├── res
#     │   └── …
#     ├── src
#     │   └── …
#     ├── AndroidManifest.xml
#     └── proguard-unity.txt
#
# Gradle directories
#
# build-android-gradle
# ├── app
# │   ├── libs
# │   ├── src
# │   │   └── main
# │   │       ├── java
# │   │       │   └── …
# │   │       ├── res
# │   │       │   └── …
# │   │       └── AndroidManifest.xml
# │   ├── build.gradle
# │   ├── gradle.properties
# │   └── progurard-rules.pro
# ├── build.gradle
# ├── settings.gradle
# └── gradlew
#
# Gradle files
#
# gradle
# ├── build.gradle
# ├── local.properties
# ├── settings.gradle
# ├── gradlew
# └── app
#     ├── build.gradle
#     └── gradle.properties

# TODO error check

pwd

prod_name=$(ls -1 build-adt)

if [[ ! -e build-android-gradle/app/src/main ]]
then
  mkdir -p build-android-gradle/app/src/main
fi

rsync -av  -delete "build-adt/$prod_name/AndroidManifest.xml"    build-android-gradle/app/src/main/AndroidManifest.xml
rsync -avr -delete "build-adt/$prod_name/assets"                 build-android-gradle/app/src/main/
rsync -av  -delete "build-adt/$prod_name/libs/unity-classes.jar" build-android-gradle/app/libs/
rsync -avr -delete "build-adt/$prod_name/libs/armeabi-v7a"       build-android-gradle/app/src/main/jniLibs/
rsync -avr -delete "build-adt/$prod_name/libs/x86"               build-android-gradle/app/src/main/jniLibs/
rsync -avr -delete "build-adt/$prod_name/res"                    build-android-gradle/app/src/main/
rsync -avr -delete "build-adt/$prod_name/src/"                   build-android-gradle/app/src/main/java/
rsync -av  -delete "build-adt/$prod_name/proguard-unity.txt"     build-android-gradle/app/proguard-unity.txt

rsync -avr -delete gradle/ build-android-gradle

echo SUCCESS

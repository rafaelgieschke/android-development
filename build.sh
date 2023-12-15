#!/bin/sh -xeu
selfdir="$(dirname -- "$(realpath -- "$0")")"

# apt-get install -y openjdk-17-jdk-headless

# Java >= 17 or:
# JAVA_HOME="$(printf %s /usr/lib/jvm/java-17-openjdk-*)"
# export JAVA_HOME

: "${ANDROID_HOME=${ANDROID_SDK_ROOT-$HOME/Android/Sdk}}"
export ANDROID_HOME

append() {
  if ! grep -Fxq -- "$2" "$1"; then
    mkdir -p -- "${1%/*}"
    printf '%s\n' "$2" >> "$1"
  fi
}

append "$ANDROID_HOME/licenses/android-sdk-license" "24333f8a63b6825ea9c5514f83c2829b004d1fee"
append "$ANDROID_HOME/licenses/android-sdk-license" "8933bad161af4178b1185d1a37fbf41ea5269c55"
append "$ANDROID_HOME/licenses/android-sdk-license" "d56f5187479451eabf01fb78af6dfcb131a6481e"

if test "$#" = "0"; then
  set -- build -x lintDebug
fi

"$selfdir/gradlew" "$@"

find . -name "*.apk"

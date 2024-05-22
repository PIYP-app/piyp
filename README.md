# piyp

## Requirements

First you must install:

- [bash (v5)](https://www.gnu.org/software/bash/)
- [mise](https://mise.jdx.dev/)

Afterwards you must run:

```sh
$ mise plugins install android-sdk https://github.com/Syquel/mise-android-sdk.git
$ mise install java yq # Install first because they are required by others tools
$ mise install
$ sdkmanager "platform-tools" "build-tools;33.0.3" "platforms;android-33" # Only if you want to build for android
$ yes | flutter doctor --android-licenses # Only if you want to build for android
```

At this point you should be ready to build app for android at least, please don't
use `flutter upgrade` since this can break installation in some ways.

If you don't want to use mise you can follow the instructions from official website.
https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download#install-the-flutter-sdk

## Getting started

### Start

To start PIYP, run the following command:

```
flutter run
```

## Create android emulator

You can create an android emulator using these commands:

```sh
$ sdkmanager "platform-tools" "build-tools;33.0.3" "platforms;android-33"
$ sdkmanager --install "system-images;android-33;google_apis;x86_64"
$ avdmanager create avd --name Pixel_8_Pro_AVD --package "system-images;android-33;google_apis;x86_64" --device "pixel_8_pro"
```

Then you must launch the emulator:

```sh
$ flutter emulators --launch Pixel_8_Pro_AVD
```

Finally you can now deploy PIYP on your emulator with:

```sh
$ flutter run
```

## FAQ

### Flutter installation

Refer to [asdf-flutter troobleshooting](https://github.com/asdf-community/asdf-flutter?tab=readme-ov-file#troubleshooting).

### Gradle

If you have an error with grade, try to run the following commands:

```sh
$ rm -rf ~/.gradle/ ~/.pub-cache
$ flutter pub get
```

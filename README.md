# saba2v2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Notes on Picking Images

This project relies on the [`file_picker`](https://pub.dev/packages/file_picker)
package in combination with [`permission_handler`](https://pub.dev/packages/permission_handler)
to read images from the device. When running on Android 13 (API 33) or newer,
the app requests `READ_MEDIA_IMAGES` permission via `Permission.photos`. On
older Android versions a fallback request for storage permission is used.

If you run the app on an emulator, ensure that the emulator actually contains
some images. Otherwise the picker may appear empty even though permissions are
granted.

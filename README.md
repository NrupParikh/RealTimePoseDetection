# pose_detection

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

OnBoard
  ├── Login  ──┐
  └── Register ─┘

Register Success → Login  
Login Success → Home

Login ↔ Register (loop-safe via Get.off)


OnBoard → Login/Register	Get.to()	Adds to stack with animation
Login ↔ Register	Get.off()	Prevents stacking screens infinitely
Register Success → Login	Get.offAll()	Clears stack and resets navigation
Login Success → Home	Get.offAll()	Clean navigation stack
Custom back behavior	Get.back() or Get.offAll()	Controlled exit flow


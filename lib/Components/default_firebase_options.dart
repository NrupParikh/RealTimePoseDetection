// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform; // Important for platform detection

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
        apiKey: "AIzaSyALN2ktxWUtclvsLjXHPrjtdGfJAGr22D4",
        projectId: "aichatbotapp-a34d8",
        storageBucket: "aichatbotapp-a34d8.firebasestorage.app",
        messagingSenderId: "910552505630",
        appId: "1:910552505630:android:846f74f80ffc1f9d327d0f",
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(          
          apiKey: "AIzaSyA78oH73ifpu-OnJehAJTyjTkXqlU6H5PI",     // iOS specific
          appId: "1:910552505630:ios:4818d6e7dfd05bed327d0f",       // iOS specific
          messagingSenderId: "910552505630", // Common
          projectId: "aichatbotapp-a34d8",   // Common
          storageBucket: "aichatbotapp-a34d8.firebasestorage.app", // Common
          // iosClientId: "YOUR_IOS_CLIENT_ID", // iOS specific for Google Sign-In, etc.
        );
      // case TargetPlatform.web:
      //   return const FirebaseOptions(
      //     apiKey: "YOUR_WEB_API_KEY",     // Web specific
      //     authDomain: "YOUR_WEB_AUTH_DOMAIN", // Web specific
      //     projectId: "YOUR_PROJECT_ID",   // Common
      //     storageBucket: "YOUR_WEB_STORAGE_BUCKET", // Common
      //     messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Common
      //     appId: "YOUR_WEB_APP_ID",       // Web specific
      //     // measurementId: "YOUR_WEB_MEASUREMENT_ID", // If Analytics is enabled
      //   );
      // You would add cases for TargetPlatform.macOS, TargetPlatform.linux, TargetPlatform.windows if needed
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
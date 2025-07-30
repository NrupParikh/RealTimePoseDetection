# Real-time Pose Detection Flutter Application with AI-Powered Chatbot

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-880E4F?style=for-the-badge&logo=githubactions&logoColor=white)
![Google ML Kit](https://img.shields.io/badge/Google%20ML%20Kit-4285F4?style=for-the-badge&logo=google&logoColor=white)
![Gemini API](https://img.shields.io/badge/Google%20Gemini-FF6F00?style=for-the-badge&logo=google&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Firestore](https://img.shields.io/badge/Firestore-FF6F00?style=for-the-badge&logo=firebase&logoColor=white)
![Dio](https://img.shields.io/badge/Dio-1976D2?style=for-the-badge&logo=codeigniter&logoColor=white)

This is a robust and feature-rich mobile application developed with Flutter, designed to provide real-time pose detection for fitness and exercise, complemented by an integrated AI-powered chatbot for enhanced user interaction. The application is built with a focus on performance, scalability, and a great user experience, adhering to modern architectural best practices.

## ✨ Features

* **Real-time Pose Detection:** Leverages Google's ML Kit to provide accurate, real-time pose analysis during exercise routines, offering users immediate feedback and guidance.
* **Comprehensive Exercise Module:**
    * **Exercise List:** Presents a curated list of various exercises.
    * **Detailed Exercise Information:** Provides in-depth descriptions and instructions for each exercise.
    * **Exercise Detection:** Guides users through exercises with real-time pose analysis.
* **AI-Powered Chatbot Integration:**
    * **Generative AI Model:** Incorporates Google's Gemini API (via `firebase_ai` or `google_generative_ai` if used directly) to power an intelligent chatbot, offering personalized assistance and information related to exercises and fitness.
    * **Firebase Remote Config:** Dynamically manages and updates chatbot configurations and prompts, ensuring flexibility and easy content updates without app redeployment.
* **Secure Authentication Module:**
    * **User Login:** Provides secure user authentication.
    * **User Registration:** Allows new users to create accounts.
    * **Logout Functionality:** Ensures secure session management.
* **User Profile Management:**
    * **User Profile Screen:** Displays user-specific information.
    * **Edit Functionality:** Enables users to update their profile details.

---

## 📱 Application Flow & Screens

The application guides users through a clear and intuitive flow, starting with authentication and leading to core functionalities.

### **Auth Module**

* **Login Screen:** Users can securely log in to their accounts.
* **Registration Screen:** New users can easily create an account.

### **After Login (Home Screen)**

Upon successful login, users are directed to the **Home Screen**, which features:

* **AI Chatbot for User Information:** An integrated chatbot immediately engages the user to gather necessary information, personalize their experience, or answer fitness-related queries.
* **Navigation Drawer:** A prominent navigation drawer provides easy access to key sections of the application:
    * **Exercise List Screen:** Displays the complete list of exercises for users to explore.
    * **Profile Screen:** Allows users to view and edit their personal profile information.
    * **Logout Option:** Provides a secure way for users to end their session.

---

## 🚀 Technologies Used

* **Flutter:** The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
* **GetX:** A high-performance, reactive, and minimalist solution for state management, dependency injection, and routing.
* **Cloud Firestore:** A flexible, scalable NoSQL cloud database used for storing and syncing user data, exercise details, and other application-specific information in real-time.
* **Google ML Kit:** For on-device machine learning capabilities, specifically real-time pose detection.
* **Google Gemini API:** To integrate advanced generative AI for the chatbot functionality.
* **Firebase:** Utilized for Firebase Remote Config to manage dynamic content and configurations, and as the underlying platform for Cloud Firestore.
* **Dio:** A powerful HTTP client for Dart, used for making API calls.
* **Shared Preferences:** For lightweight local data storage of user preferences and session data.
* **Permission Handler:** To manage and request necessary permissions, such as camera access.

---

## 📦 Plugins Used

The following Flutter plugins are integral to the application's functionality:

* `get`: For state management, dependency injection, and navigation.
* `camera`: Provides access to the device's cameras for video streaming and image capture, crucial for pose detection.
* `google_mlkit_pose_detection`: Integrates Google's ML Kit for real-time pose detection capabilities.
* `permission_handler`: Simplifies requesting and managing various platform permissions, such as camera access.
* `shared_preferences`: For lightweight local storage of key-value pairs, used to store user data.
* `firebase_core`: The foundational plugin required to initialize and use any Firebase service.
* `firebase_ai` (or `google_generative_ai`): For interacting with the Gemini API to power the AI chatbot.
* `cloud_firestore`: Integrates Cloud Firestore for real-time NoSQL database capabilities.
* `firebase_remote_config`: Enables dynamic configuration updates from the Firebase console without app redeployment.
* `dio`: A powerful HTTP client for making API requests.
* `pretty_dio_logger`: A Dio interceptor for pretty-printing network requests and responses in the console, aiding in debugging.

---

## 🏗️ Architecture

The application is built following the **MVVM (Model-View-ViewModel)** architectural pattern. This approach promotes a clear separation of concerns, leading to a more modular, testable, and maintainable codebase.

* **Model:** Represents the data and business logic (e.g., user data, exercise details, handled by Cloud Firestore).
* **View:** The UI layer responsible for displaying information and capturing user input.
* **ViewModel:** Acts as an intermediary between the Model and View, handling UI logic and data preparation.

---


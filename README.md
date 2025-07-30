# Real-time Pose Detection Flutter Application with AI-Powered Chatbot

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-880E4F?style=for-the-badge&logo=githubactions&logoColor=white)
![Google ML Kit](https://img.shields.io/badge/Google%20ML%20Kit-4285F4?style=for-the-badge&logo=google&logoColor=white)
![Gemini API](https://img.shields.io/badge/Google%20Gemini-FF6F00?style=for-the-badge&logo=google&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Firestore](https://img.shields.io/badge/Firestore-FF6F00?style=for-the-badge&logo=firebase&logoColor=white)
![Dio](https://img.shields.io/badge/Dio-1976D2?style=for-the-badge&logo=codeigniter&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)

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

## 🚀 CI/CD Pipeline with GitHub Actions

This project implements an automated Continuous Integration/Continuous Delivery (CI/CD) pipeline using **GitHub Actions**. This pipeline is configured to:

* **Automate Mobile Builds:** Automatically generates release-ready builds for both Android (`.apk` and/or `.aab`) and iOS (`.ipa` - with proper Apple Developer account setup) platforms whenever changes are pushed to specific branches (e.g., `main` or `release`).
* **Ensure Code Quality:** Can be extended to run tests, linting, and code analysis checks.
* **Streamline Development:** Reduces manual effort, ensures consistent build processes, and accelerates the delivery of new features and updates.

The workflow files for these automated processes can be found in the `.github/workflows/` directory of this repository.

---

## 🏗️ Architecture

The application is built following the **MVVM (Model-View-ViewModel)** architectural pattern. This approach promotes a clear separation of concerns, leading to a more modular, testable, and maintainable codebase.

* **Model:** Represents the data and business logic (e.g., user data, exercise details, handled by Cloud Firestore).
* **View:** The UI layer responsible for displaying information and capturing user input.
* **ViewModel:** Acts as an intermediary between the Model and View, handling UI logic and data preparation.
---

---
## 📸 Screenshot

<img width="150" height="400" alt="0_splash" src="https://github.com/user-attachments/assets/d9192de0-1c51-46ad-a895-5ca807f91d50" />
<img width="150" height="400" alt="1_on_board" src="https://github.com/user-attachments/assets/49664109-1db9-430d-aee3-b0e4e02fe14c" />
<img width="150" height="400" alt="2_login" src="https://github.com/user-attachments/assets/1a579a1e-0cae-4044-b039-267fb02cb752" />
<img width="150" height="400" alt="3_create_account" src="https://github.com/user-attachments/assets/da7b8281-c9f6-4cd6-aaa6-1ecfdb608542" />
<img width="150" height="400" alt="4_ex_list" src="https://github.com/user-attachments/assets/04570713-155a-44a6-abea-496868f991b7" />
<img width="150" height="500" alt="6_drawer" src="https://github.com/user-attachments/assets/e5452030-f0a4-4865-ae64-731696659cb2" />
<img width="150" height="400" alt="3_1_chat_bot" src="https://github.com/user-attachments/assets/666ab244-e1bd-48e5-a31a-8084143d3888" />
<img width="150" height="400" alt="3_2_chat_bot" src="https://github.com/user-attachments/assets/3e2a30ba-412a-4faa-94e9-fd377bc66e86" />
<img width="150" height="400" alt="4_1_pushup" src="https://github.com/user-attachments/assets/4b5dbb95-45b1-46ff-8162-053e4b1cc0dd" />
<img width="150" height="400" alt="4_2_squat" src="https://github.com/user-attachments/assets/a5d9c5ba-4d80-44b1-bf6d-e8bdfccf1ac4" />
<img width="150" height="400" alt="4_3_jumping_jack" src="https://github.com/user-attachments/assets/9b045017-6052-4df8-b209-1a3fea05e472" />
<img width="150" height="400" alt="4_4_plank_to_downward_dog" src="https://github.com/user-attachments/assets/e1ab62ca-d607-4cf4-bc51-ff8a3e9f229d" />
<img width="150" height="400" alt="4_5_over_head_clap" src="https://github.com/user-attachments/assets/f5f18554-761e-48df-a5a1-76b4c7245f23" />
<img width="150" height="400" alt="7_logout" src="https://github.com/user-attachments/assets/685169a8-0f05-4319-aa8f-32a281c10341" />

---



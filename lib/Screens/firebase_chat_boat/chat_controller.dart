// import 'package:firebase_ai/firebase_ai.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/material.dart'; // For TextEditingController, ScrollController, etc.
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:pose_detection/Components/session_expire_controller.dart';
// import 'package:pose_detection/Constants/app_string.dart';
// import 'package:pose_detection/Singleton/api_service_singleton.dart';
// import 'package:pose_detection/api/apiModels/profile_response.dart';
// import 'package:pose_detection/api/api_service.dart';
// import 'package:pose_detection/main.dart';
// import 'package:tuple/tuple.dart';

// class ChatController extends GetxController {
//   // Reactive variables for UI updates
//   final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
//   final TextEditingController textController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   // User data fields (reactive where needed for potential UI updates or logging)
//   RxString userName = ''.obs;
//   RxnInt userAge = RxnInt(null); // Rxn for nullable int
//   RxnDouble userHeight = RxnDouble(null); // Rxn for nullable double
//   RxnDouble userWeight = RxnDouble(null); // Rxn for nullable double
//   RxString userGender = ''.obs;
//   RxString userGoal = ''.obs;

//   RxInt questionIndex = 0.obs; // Tracks the current question
//   RxBool isUserDataSaved = false.obs;

//   // Firebase service instances
//   late GenerativeModel _geminiModel;
//   late FirebaseRemoteConfig _remoteConfig;
//   final RxList<String> questions =
//       <String>[].obs; // Reactive list for questions

//   final ApiService _apiService = ApiServiceSingleton().apiService;
//   RxBool isLoading = false.obs;

//   final SessionExpireController sessionController =
//       Get.find<SessionExpireController>();

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeFirebaseServices();
//   }

//   @override
//   void onClose() {
//     textController.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }

//   Future<void> _initializeFirebaseServices() async {
//     _remoteConfig = FirebaseRemoteConfig.instance;

//     await _remoteConfig.setDefaults(<String, dynamic>{
//       'chatbot_questions': jsonEncode([
//         "What's your name?",
//         "How old are you?",
//         "What's your height in cm?",
//         "What's your weight in kg?",
//         "What's your gender? (Male/Female/Other)",
//         "What's your fitness goal?",
//       ]),
//     });

//     await _remoteConfig.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(minutes: 1),
//         minimumFetchInterval: const Duration(seconds: 10),
//       ),
//     );

//     try {
//       await _remoteConfig.fetchAndActivate();
//       _loadQuestionsFromRemoteConfig();
//     } on FirebaseException catch (e) {
//       debugPrint('Firebase Remote Config fetch failed: $e');
//       _loadQuestionsFromRemoteConfig();
//     } catch (e) {
//       debugPrint('Unknown error fetching remote config: $e');
//       _loadQuestionsFromRemoteConfig();
//     }

//     _geminiModel = FirebaseAI.googleAI().generativeModel(
//       model:
//           'gemini-1.5-flash-latest', // Changed to gemini-pro as 2.5 is not universally available for firebase_ai
//     );

//     _startChat();
//   }

//   void _loadQuestionsFromRemoteConfig() {
//     try {
//       final String questionsJsonString = _remoteConfig.getString(
//         'chatbot_questions',
//       );
//       final List<dynamic> decodedList = jsonDecode(questionsJsonString);
//       questions.assignAll(
//         decodedList.cast<String>(),
//       ); // Use assignAll for RxList
//       debugPrint("Questions loaded from Remote Config: ${questions.length}");
//     } catch (e) {
//       debugPrint("Error decoding remote config questions: $e");
//       questions.assignAll([
//         // Fallback using assignAll
//         "What's your name?",
//         "How old are you?",
//         "What's your height in cm?",
//         "What's your weight in kg?",
//         "What's your gender? (Male/Female/Other)",
//         "What's your fitness goal?",
//       ]);
//     }
//   }

//   void _startChat() {
//     _addBotMessage("Welcome to the registration! Let's get started.");
//     _askNextQuestion();
//   }

//   void updateProfileStatus() {
//     final userData = secureStorage.getUserData();
//     if (userData != null) {
//       userData.profileDataAvailable = true;
//       secureStorage.storeUserData(userData);
//       isUserDataSaved.value = true;
//     }
//   }

//   void _addBotMessage(String message) {
//     messages.add({'sender': 'bot', 'text': message}); // Add to reactive list
//     _scrollToBottom();
//   }

//   void _addUserMessage(String message) {
//     messages.add({'sender': 'user', 'text': message}); // Add to reactive list
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 30),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _askNextQuestion() {
//     Future.delayed(const Duration(milliseconds: 50), () {
//       if (questionIndex.value < questions.length) {
//         _addBotMessage(questions[questionIndex.value]);
//       } else if (questionIndex.value == questions.length) {
//         _showSummary();
//       }
//     });
//   }

//   Future<void> handleUserResponse(String response) async {
//     _addUserMessage(response);
//     bool proceedToNextQuestion = true;

//     String currentField = '';
//     switch (questionIndex.value) {
//       case 0:
//         currentField = 'name';
//         break;
//       case 1:
//         currentField = 'age';
//         break;
//       case 2:
//         currentField = 'height';
//         break;
//       case 3:
//         currentField = 'weight';
//         break;
//       case 4:
//         currentField = 'gender';
//         break;
//       case 5:
//         currentField = 'goal';
//         break;
//     }

//     try {
//       final prompt = """
//       Extract the user's '$currentField' from the following input.
//       If the '$currentField' is numerical (like age, height, weight), extract only the number.
//       If the '$currentField' is gender, prefer 'Male', 'Female', or 'Other'.
//       If the '$currentField' is name or goal, extract the most relevant text.
//       If the information is not present or unclear, or if the input is irrelevant to the question, respond with "N/A".

//       User Input: "$response"

//       Output the extracted value as plain text.
//       """;

//       final content = [Content.text(prompt)];
//       final generativeResponse = await _geminiModel.generateContent(content);

//       final extractedValue = generativeResponse.text?.trim() ?? 'N/A';

//       if (extractedValue == 'N/A' || extractedValue.isEmpty) {
//         _addBotMessage(
//           "I couldn't understand your $currentField. Could you please rephrase or state it clearly?",
//         );
//         proceedToNextQuestion = false;
//       } else {
//         switch (questionIndex.value) {
//           case 0: // Name
//             userName.value = extractedValue;
//             break;
//           case 1: // Age
//             final age = int.tryParse(extractedValue);
//             if (age == null || age <= 0 || age > 120) {
//               _addBotMessage(AppStrings.valEnterValidAge);
//               proceedToNextQuestion = false;
//             } else {
//               userAge.value = age;
//             }
//             break;
//           case 2: // Height
//             final height = double.tryParse(extractedValue);
//             if (height == null || height <= 50 || height > 250) {
//               _addBotMessage(AppStrings.valEnterValidHeight);
//               proceedToNextQuestion = false;
//             } else {
//               userHeight.value = height;
//             }
//             break;
//           case 3: // Weight
//             final weight = double.tryParse(extractedValue);
//             if (weight == null || weight <= 20 || weight > 200) {
//               _addBotMessage(AppStrings.valEnterValidWeight);
//               proceedToNextQuestion = false;
//             } else {
//               userWeight.value = weight;
//             }
//             break;
//           case 4: // Gender
//             final normalizedGender = extractedValue.toLowerCase();
//             if (['male', 'female', 'other'].contains(normalizedGender)) {
//               userGender.value = normalizedGender.replaceFirst(
//                 normalizedGender[0],
//                 normalizedGender[0].toUpperCase(),
//               );
//             } else {
//               _addBotMessage(AppStrings.valEnterValidGender);
//               proceedToNextQuestion = false;
//             }
//             break;
//           case 5: // Goal
//             userGoal.value = extractedValue;
//             break;
//         }
//       }
//     } catch (e) {
//       _addBotMessage(
//         "An error occurred while processing your request with AI. Please try again. ($e)",
//       );
//       proceedToNextQuestion = false;
//     }

//     if (proceedToNextQuestion) {
//       questionIndex.value++; // Increment reactive variable
//       _askNextQuestion();
//     }
//   }

//   Future<void> _saveUserDataToFirestore() async {
//     final String userId = DateTime.now().millisecondsSinceEpoch.toString();

//     try {
//       await FirebaseFirestore.instance
//           .collection('registrations')
//           .doc(userId)
//           .set({
//             'name': userName.value,
//             'age': userAge.value,
//             'height': userHeight.value,
//             'weight': userWeight.value,
//             'gender': userGender.value,
//             'goal': userGoal.value,
//             'timestamp': FieldValue.serverTimestamp(),
//           });
//       _addBotMessage(
//         "Your details have been successfully saved to our records!",
//       );
//       debugPrint("User data saved to Firestore for ID: $userId");

//       await updateUserProfile().then((result) {
//         if (result.item3 == 401) {
//           if (Get.context != null && !Get.isDialogOpen!) {
//            sessionController.showSessionExpiredDialog(Get.context!, result.item2.toString());
//           }
//         }
//       });
//     } catch (e) {
//       isUserDataSaved.value = false;

//       _addBotMessage(
//         "Failed to save your details. Please check your internet connection and try again later.",
//       );
//       debugPrint("Error saving user data to Firestore: $e");
//     }
//   }

//   void _showSummary() {
//     String summary =
//         "Thanks for registering, ${userName.value.isNotEmpty ? userName.value : 'there'}! Here's what we got:\n\n"
//         "Name: ${userName.value.isNotEmpty ? userName.value : 'N/A'}\n"
//         "Age: ${userAge.value?.toString() ?? 'N/A'}\n"
//         "Height: ${userHeight.value?.toStringAsFixed(1) ?? 'N/A'} cm\n"
//         "Weight: ${userWeight.value?.toStringAsFixed(1) ?? 'N/A'} kg\n"
//         "Gender: ${userGender.value.isNotEmpty ? userGender.value : 'N/A'}\n"
//         "Goal: ${userGoal.value.isNotEmpty ? userGoal.value : 'N/A'}";
//     _addBotMessage(summary);

//     _saveUserDataToFirestore();
//   }

//   Future<Tuple3<bool, String?, int>> updateUserProfile() async {
//     final name = userName.value;
//     final age = userAge.value;
//     final height = userHeight.value;
//     final weight = userWeight.value;
//     final gender = userGender.value;
//     final goal = userGoal.value;
//     final userId = secureStorage.getUserData()?.id;

//     try {
//       isLoading.value = true;
//       var appResponse = await _apiService.updateUserProfile(
//         id: userId ?? 0,
//         name: name,
//         age: age ?? 0,
//         height: height ?? 0.0,
//         weight: weight ?? 0.0,
//         gender: gender,
//         goal: goal,
//       );
//       if (appResponse.statusCode == 200) {
//         isLoading.value = false;
//         if (appResponse.data is Map<String, dynamic>) {
//           try {
//             final ProfileResponse data = ProfileResponse.fromJson(
//               appResponse.data,
//             );
//             debugPrint("Tag_data ${data.profile}");
//             secureStorage.storeProfileData(data.profile);
//             updateProfileStatus();
//             return Tuple3(
//               true,
//               appResponse.message.toString(),
//               appResponse.statusCode.toInt(),
//             );
//           } catch (e) {
//             isLoading.value = false;
//             return Tuple3(
//               false,
//               "Error parsing ApiResponse",
//               appResponse.statusCode.toInt(),
//             );
//           }
//         } else {
//           isLoading.value = false;
//           return Tuple3(
//             false,
//             "appResponse.data is not a Map",
//             appResponse.statusCode.toInt(),
//           );
//         }
//       } else {
//         isLoading.value = false;
//         return Tuple3(
//           false,
//           appResponse.message.toString(),
//           appResponse.statusCode.toInt(),
//         );
//       }
//     } catch (ex) {
//       isLoading.value = false;
//       return Tuple3(false, "$ex", 0);
//     }
//   }
// }

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart'; // For TextEditingController, ScrollController, etc.
import 'package:get/get.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/profile_response.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class ChatControllerNew extends GetxController {
  // Reactive variables for UI updates
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // User data fields (reactive where needed for potential UI updates or logging)
  RxString userName = ''.obs;
  RxnInt userAge = RxnInt(null);
  RxnDouble userHeight = RxnDouble(null);
  RxnDouble userWeight = RxnDouble(null);
  RxString userGender = ''.obs;
  RxString userGoal = ''.obs;

  RxInt questionIndex = 0.obs; // Tracks the current question
  RxBool isUserDataSaved = false.obs;

  // Preset questions (no remote config)
  final RxList<String> questions = <String>[  
    "What's your name?",
    "How old are you?",
    "What's your height in cm?",
    "What's your weight in kg?",
    "What's your gender? (Male/Female/Other)",
    "What's your fitness goal?",
  ].obs;

  // Firebase / API service instances
  late GenerativeModel _geminiModel;
  final ApiService _apiService = ApiServiceSingleton().apiService;
  RxBool isLoading = false.obs;

  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  @override
  void onInit() {
    super.onInit();
    _initializeFirebaseServices();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _initializeFirebaseServices() async {
    _geminiModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-1.5-flash-latest',
    );
    _startChat();
  }

  void updateProfileStatus() {
    final userData = secureStorage.getUserData();
    if (userData != null) {
      userData.profileDataAvailable = true;
      secureStorage.storeUserData(userData);
      isUserDataSaved.value = true;
    }
  }

  void _addBotMessage(String message) {
    messages.add({'sender': 'bot', 'text': message});
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    messages.add({'sender': 'user', 'text': message});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 30),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _askNextQuestion() {
    if (questionIndex.value < questions.length) {
      _addBotMessage(questions[questionIndex.value]);
    } else if (questionIndex.value == questions.length) {
      _showSummary();
    }
  }

  void _startChat() {
    _addBotMessage("Welcome to the registration! Let's get started.");
    _askNextQuestion();
  }

  Future<void> handleUserResponse(String response) async {
    _addUserMessage(response);
    bool proceedToNextQuestion = true;

    String currentField = '';
    switch (questionIndex.value) {
      case 0:
        currentField = 'name';
        break;
      case 1:
        currentField = 'age';
        break;
      case 2:
        currentField = 'height';
        break;
      case 3:
        currentField = 'weight';
        break;
      case 4:
        currentField = 'gender';
        break;
      case 5:
        currentField = 'goal';
        break;
    }

    try {
      final prompt = """
      Extract the user's '$currentField' from the following input.
      If the '$currentField' is numerical (like age, height, weight), extract only the number.
      If the '$currentField' is gender, prefer 'Male', 'Female', or 'Other'.
      If the '$currentField' is name or goal, extract the most relevant text.
      If the information is not present or unclear, or if the input is irrelevant to the question, respond with "N/A".

      User Input: "$response"

      Output the extracted value as plain text.
      """;

      final content = [Content.text(prompt)];
      final generativeResponse = await _geminiModel.generateContent(content);

      final extractedValue = generativeResponse.text?.trim() ?? 'N/A';

      if (extractedValue == 'N/A' || extractedValue.isEmpty) {
        _addBotMessage(
          "I couldn't understand your $currentField. Could you please rephrase or state it clearly?",
        );
        proceedToNextQuestion = false;
      } else {
        switch (questionIndex.value) {
          case 0: // Name
            userName.value = extractedValue;
            break;
          case 1: // Age
            final age = int.tryParse(extractedValue);
            if (age == null || age <= 0 || age > 120) {
              _addBotMessage(AppStrings.valEnterValidAge);
              proceedToNextQuestion = false;
            } else {
              userAge.value = age;
            }
            break;
          case 2: // Height
            final height = double.tryParse(extractedValue);
            if (height == null || height <= 50 || height > 250) {
              _addBotMessage(AppStrings.valEnterValidHeight);
              proceedToNextQuestion = false;
            } else {
              userHeight.value = height;
            }
            break;
          case 3: // Weight
            final weight = double.tryParse(extractedValue);
            if (weight == null || weight <= 20 || weight > 200) {
              // Ideally use valEnterValidWeight if exists; fallback to height string if not.
              _addBotMessage(AppStrings.valEnterValidHeight);
              proceedToNextQuestion = false;
            } else {
              userWeight.value = weight;
            }
            break;
          case 4: // Gender
            final normalizedGender = extractedValue.toLowerCase();
            if (['male', 'female', 'other'].contains(normalizedGender)) {
              userGender.value = normalizedGender.replaceFirst(
                normalizedGender[0],
                normalizedGender[0].toUpperCase(),
              );
            } else {
              _addBotMessage(AppStrings.valEnterValidGender);
              proceedToNextQuestion = false;
            }
            break;
          case 5: // Goal
            userGoal.value = extractedValue;
            break;
        }
      }
    } catch (e) {
      _addBotMessage(
        "An error occurred while processing your request with AI. Please try again. ($e)",
      );
      proceedToNextQuestion = false;
    }

    if (proceedToNextQuestion) {
      questionIndex.value++;
      _askNextQuestion();
    }
  }

  void _showSummary() async {
    String summary =
        "Thanks for registering, ${userName.value.isNotEmpty ? userName.value : 'there'}! Here's what we got:\n\n"
        "Name: ${userName.value.isNotEmpty ? userName.value : 'N/A'}\n"
        "Age: ${userAge.value?.toString() ?? 'N/A'}\n"
        "Height: ${userHeight.value?.toStringAsFixed(1) ?? 'N/A'} cm\n"
        "Weight: ${userWeight.value?.toStringAsFixed(1) ?? 'N/A'} kg\n"
        "Gender: ${userGender.value.isNotEmpty ? userGender.value : 'N/A'}\n"
        "Goal: ${userGoal.value.isNotEmpty ? userGoal.value : 'N/A'}";
    _addBotMessage(summary);

    final result = await updateUserProfile();
    if (result.item1) {
      _addBotMessage(
        "Your details have been successfully saved to our records!",
      );
    } else {
      if (result.item3 == 401) {
        if (Get.context != null && !Get.isDialogOpen!) {
          sessionController.showSessionExpiredDialog(
            Get.context!,
            result.item2.toString(),
          );
        }
      } else {
        _addBotMessage(
          "Failed to save your details: ${result.item2 ?? 'Unknown error'}",
        );
      }
    }
  }

  Future<Tuple3<bool, String?, int>> updateUserProfile() async {
    final name = userName.value;
    final age = userAge.value;
    final height = userHeight.value;
    final weight = userWeight.value;
    final gender = userGender.value;
    final goal = userGoal.value;
    final userId = secureStorage.getUserData()?.id;

    try {
      isLoading.value = true;
      var appResponse = await _apiService.updateUserProfile(
        id: userId ?? 0,
        name: name,
        age: age ?? 0,
        height: height ?? 0.0,
        weight: weight ?? 0.0,
        gender: gender,
        goal: goal,
      );
      if (appResponse.statusCode == 200) {
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            final ProfileResponse data = ProfileResponse.fromJson(
              appResponse.data,
            );
            debugPrint("Tag_data ${data.profile}");
            secureStorage.storeProfileData(data.profile);
            updateProfileStatus();
            return Tuple3(
              true,
              appResponse.message.toString(),
              appResponse.statusCode.toInt(),
            );
          } catch (e) {
            isLoading.value = false;
            return Tuple3(
              false,
              "Error parsing ApiResponse",
              appResponse.statusCode.toInt(),
            );
          }
        } else {
          isLoading.value = false;
          return Tuple3(
            false,
            "appResponse.data is not a Map",
            appResponse.statusCode.toInt(),
          );
        }
      } else {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      }
    } catch (ex) {
      isLoading.value = false;
      return Tuple3(false, "$ex", 0);
    }
  }
}

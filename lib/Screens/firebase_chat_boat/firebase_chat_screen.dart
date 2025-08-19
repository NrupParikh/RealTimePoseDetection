import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/chat_controller_new.dart';

import '../../Constants/page_name.dart';

// We can now make this a StatelessWidget as state is managed by ChatController
class FirebaseChatScreen extends StatefulWidget {
  const FirebaseChatScreen({super.key});

  @override
  State<FirebaseChatScreen> createState() => _FirebaseChatScreenState();
}

class _FirebaseChatScreenState extends State<FirebaseChatScreen> {
  final chatController = Get.find<ChatControllerNew>();
  @override
  void initState() {
    super.initState();
    ever(chatController.isUserDataSaved, (bool saved) {
      if (saved == true) {
        navigateToDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the controller and make it available across the widget tree
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'User Registration Chatbot',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Existing UI background and chat interface
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: FrostedGlass(
              applyFilter: false,
              borderRadius: BorderRadius.zero,
              gradientColors: [
                ColorConstants.startColor.withValues(alpha: 0.8),
                ColorConstants.endColor.withValues(alpha: 0.8),
              ],
              child: SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    // Message List
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          controller: chatController.scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          itemCount: chatController.messages.length,
                          itemBuilder: (context, index) {
                            final message = chatController.messages[index];
                            final bool isBot = message['sender'] == 'bot';
                            return Align(
                              alignment:
                                  isBot
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isBot
                                          ? Colors.blue[100]
                                          : Colors.green[100],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15.0),
                                    topRight: const Radius.circular(15.0),
                                    bottomLeft:
                                        isBot
                                            ? const Radius.circular(5.0)
                                            : const Radius.circular(15.0),
                                    bottomRight:
                                        isBot
                                            ? const Radius.circular(15.0)
                                            : const Radius.circular(5.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message['text']!,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(height: 1.0),
                    // Input Field
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: chatController.textController,
                              decoration: InputDecoration(
                                hintText: 'Type your answer...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0,
                                ),
                              ),
                              onSubmitted: (text) {
                                if (text.isNotEmpty &&
                                    chatController.questionIndex.value <=
                                        chatController.questions.length) {
                                  chatController.handleUserResponse(text);
                                  chatController.textController.clear();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          FloatingActionButton(
                            onPressed: () {
                              if (chatController
                                      .textController
                                      .text
                                      .isNotEmpty &&
                                  chatController.questionIndex.value <=
                                      chatController.questions.length) {
                                chatController.handleUserResponse(
                                  chatController.textController.text,
                                );
                                chatController.textController.clear();
                              }
                            },
                            mini: true,
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Show loader overlay when user data is saved
          Obx(() {
            if (chatController.isUserDataSaved.value ||
                chatController.isLoading.value) {
              return Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        chatController.isLoading.value
                            ? "Saving data ..."
                            : "Navigating to Dashboard",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void navigateToDashboard() {
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(PageName.dashboard);
    });
  }
}

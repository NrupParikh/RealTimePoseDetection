// lib/services/gemini_api_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';

class GeminiApiService {
  final Dio dio = Dio();
  final String apiKey = "AIzaSyAM8DEQeH0UN4HnTG7KNWsxckyWN1TpcBc";

  String get url =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

  Future<Map<String, dynamic>> fetchJsonResponse(String prompt) async {
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
      "generationConfig": {"response_mime_type": "application/json"},
    };

    try {
      final response = await dio.post(url, data: requestBody);

       // Print the request
      print("\n===== Gemini API Request =====");
      print("URL: $url");
      print("Prompt:\n$prompt");
      print("Request Body: ${jsonEncode(requestBody)}");

      // Print raw response
      print("\n===== Gemini API Raw Response =====");
      print("Status Code: ${response.statusCode}");
      print("Data: ${jsonEncode(response.data)}");

      if (response.statusCode == 200) {
        final responseBody = response.data;
        final jsonString =
            responseBody['candidates'][0]['content']['parts'][0]['text'];
        return json.decode(jsonString) as Map<String, dynamic>;
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          "Network Error: ${e.response?.data?['error']?['message'] ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected Error: ${e.toString()}");
    }
  }
}

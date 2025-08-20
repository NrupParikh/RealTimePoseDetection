class GeminiPrompt {
  // Gemini Chatbot Extraction prompt
  static String getExtractionPrompt({
    required String currentField,
    required String response,
  }) {
    return """
      Extract the user's '$currentField' from the following input.
      If the '$currentField' is numerical (like age, height, weight), extract only the number.
      If the '$currentField' is gender, prefer 'Male', 'Female', or 'Other'.
      If the '$currentField' is name or goal, extract the most relevant text.
      If the information is not present or unclear, or if the input is irrelevant to the question, respond with "N/A".

      User Input: "$response"

      Output the extracted value as plain text.
      """;
  }

  // Gemini Chatbot summary prompt
  static String formatSummary({
    required String userName,
    required int? userAge,
    required double? userHeight,
    required double? userWeight,
    required String userGender,
    required String userGoal,
    required int? goalDuration, // NEW
  }) {
    final name = userName.isNotEmpty ? userName : 'User';
    final age = userAge?.toString() ?? '0';
    final height = userHeight?.toStringAsFixed(1) ?? '0';
    final weight = userWeight?.toStringAsFixed(1) ?? '0';
    final gender = userGender.isNotEmpty ? userGender : 'Male';
    final goal = userGoal.isNotEmpty ? userGoal : 'Lose weight';
    final duration = goalDuration?.toString() ?? '0';

    return """
Thanks for registering, $name! Here's what we got:

Name: ${userName.isNotEmpty ? userName : 'User'}
Age: $age
Height: $height cm
Weight: $weight kg
Gender: $gender
Goal: $goal
Duration: $duration week(s)
""";
  }

  static String taskDescForFitnessPlan = """
1. Recommend suitable exercises from this list: [pushup, squat, jumpingJack, plankToDownwardDog, overHeadArmClap]. Include sets/reps or a duration for each.
2. Estimate the total calories burned per day and per week.
""";

  static String jsonStructureForFitnessPlan = """
{
  "workout_plan": [
    {
      "exercise_name": "string",
      "type": "string (either 'reps' or 'duration')",
      "value": "string"
    }
  ],
  "estimated_calories_burned": {
    "per_day": integer,
    "per_week": integer
  }
}
""";

  static String taskDescForFitnessTips =
      "1. Recommend up to 3 short fitness tips including food habits and work-life balance.";
  static String jsonStructureForFitnessTips = """
  {
    "fitness_tips": [
      "string",
      "string",
      "string"
    ]
  }
  """;

  static String buildFitnessPrompt({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
    required int goalDuration,
    required String taskDescription,
    required String jsonStructure,
  }) {
    return """
You are a fitness expert. Based on the user profile below, generate a JSON response.

User Profile:
- Age: $age
- Gender: $gender
- Height: ${height}cm
- Weight: ${weight}kg
- Goal: $goal
- Duration: ${goalDuration}week

Tasks:
$taskDescription

Instructions for the output:
- Return ONLY a valid JSON object.
- Do not use markdown, comments, or any explanatory text outside of the JSON structure.
- The JSON object must strictly follow this exact structure:
$jsonStructure
""";
  }

  // =================== STATIC RESPONSE FOR TEST ONLY
  static const String recommandedExerciseStaticResponse = '''
  { 
    "workout_plan": [
        {
            "exercise_name": "pushup",
            "type": "reps",
            "value": "3 sets of 15 reps"
        },
        {
            "exercise_name": "squat",
            "type": "reps",
            "value": "3 sets of 10 reps"
        },
        {
            "exercise_name": "jumpingJack",
            "type": "duration",
            "value": "3 sets of as many reps as possible (AMRAP)"
        },
        {
            "exercise_name": "plankToDownwardDog",
            "type": "reps",
            "value": "3 sets of 8 reps"
        },
        {
            "exercise_name": "overHeadArmClap",
            "type": "duration",
            "value": "3 sets of 30 seconds"
        }
    ],
    "estimated_calories_burned": {
        "per_day": 300,
        "per_week": 2100
    }
  }
  ''';

  static const String fitnessTipsStaticResponse = '''
  {
  "fitness_tips": [
    "Prioritize whole, unprocessed foods and limit sugary drinks and snacks to reduce calorie intake and support weight loss.",
    "Incorporate regular physical activity, such as brisk walking or jogging, for at least 30 minutes most days of the week.",
    "Practice mindful eating by paying attention to hunger cues and savoring each bite to prevent overeating and promote a healthier relationship with food."
  ]
}
''';
}
class AppStrings {
  static const appName = "Pose Detection";

  static const login = "LOGIN";
  static const register = "SIGN UP";
  static const registerTitle = "Don't have an account? ";
  static const signupTitle = 'SignUp';
  static const loginMsg = 'welcome back';
  static const registerMsg = 'Create an account';

  static const loginTitleButton = "Already have an account? ";
  static const loginButtonTitle = 'Login';

  // ========== VALIDATION MESSAGES
  // static const valEnterEmailOrPhoneNumber = "Please enter email ";

  // ========== HINT

  static const email = "Email";
  static const password = "Password";
  static const valEnterEmail = "Please enter email";
  static const valEnterPassword = "Please enter password";
  static const valEnterValidEmail = "Please enter valid email";
  static const valEnterValidPassword =
      "Password must be more than 6 character long";

  static const name = "Name";
  static const age = "Age";
  static const height = "Height";
  static const weight = "Weight";
  static const gender = "Gender";
  static const goal = "Goal";
  static const goalDuration = "Goal Duration (In week(s))";

  static const msgConnectInternet = "Please connect Internet";
  static const msgConnectionTimeOut = "Connection Timeout Exception";
  static const msgCanceled = "Canceled";
  static const msgNetworkErr = 'Network Error';
  static const msgSomethingWentWrong = "Something went wrong";

  static const valEnterUserName = "Please enter user name";
  static const valEnterValidAge =
      "Please enter a valid age (e.g., between 0 to 120).";
  static const valEnterValidHeight =
      "Please enter a valid height in cm (e.g., between 50 cm to 250 cm).";
  static const valEnterValidWeight =
      "Please enter a valid weight in kg (e.g., between 20 kg to 200 kg).";
  static const valEnterValidGender =
      "Please specify your gender as Male, Female, or Other.";
  static const valEnterGoal = "Please enter goal";
  static const valEnterGoalDuration = "Please enter goal duration";
  static const valEnterValidGoalDuration = "Please enter a valid duration between 1 and 52 weeks.";

  static const noChangesMade = "No changes made to the profile";

  static const msgSessionExpired =
      "Your session has expired. Please log in again.";

  static const String poseTips = "Pose Tips";
  static const String advantages = "Advantages";
  static const aboutBmi = "About BMI";
  static const aboutGoal = "About Goal";
  static const String description = "Description";
  static const String bmiDescription =
      "BMI (Body Mass Index) is a tool used to estimate body fat based on your height and weight. It's a quick way to screen for weight categories that may lead to health problems";
  static const String bmiHowToCalculate = "How it's calculated";
  static const String bmiHowToCalculateDesc = """
- The formula is: weight (in kilograms) divided by the square of your height (in meters).
- Your height is first converted from centimeters to meters.""";
  static const String bmiCategories = "BMI Categories";
  static const String bmiCategoriesDesc = """
- Underweight: Below 18.5
- Normal: 18.5-24.9
- Overweight: 25.0-29.9
- Obese: 30.0 or higher
""";

static const String goalDescription = "To acheive your goal you need to perform recommanded exercies and follow the given fitness tips during give time period";
static const String goalDurationStatus = "Duration status";
static const String caloriesStatus = "Calories Status";
  static const aboutReEx = "About Recommanded Exercise";
  static const String recommandedExDescription =
      "This plan is tailored to your profile and includes a selection of exercises from the following: Push-up, Squat, Jumping Jack, Plank to Downward Dog, and Overhead Arm Clap.Each exercise includes the suggested number of sets/repetitions or a duration, helping you follow a structured routine";
  static const String whatItTells =
      "The plan also provides an estimated calorie burn, showing";
  static const String whatItTellsValue = """
- Per Day : The approximate calories you'll burn by completing the daily routine.
- Per Week : The total estimated calories burned if the plan is followed consistently for seven days.""";

  static const String pushup = "Push Up";
  static const String squat = "Squat";
  static const String plankToDownwardDog = "Plank to Downward Dog";
  static const String jumpingJack = "Jumping Jack";
  static const String overHeadArmClap = "Over Head Arm Clap";

  static const String pushUpGif = 'assets/myGif/pushup.gif';
  static const String squatGif = 'assets/myGif/squat.gif';
  static const String plankToDownwardDogGif =
      'assets/myGif/plank_to_downward_dog.gif';
  static const String jumpingJackGif = 'assets/myGif/jumping_jack.gif';
  static const String overHeadArmClapGif = 'assets/myGif/overhead_clap.gif';

  static const String titleDashBoard = "Dashboard";
  static String greeting(String? name) => 'Hi, ${name ?? 'User'}';
  static const String welcomMsg = "Let's reach your goal!";
  static const String bmiAndHealthStatus = "BMI & Health Status";
  static const String recommandedExercise = "Recommended Exercises";
  static String goalText(int? perDay, int? perWeek) =>
      'Goal : Burn ${perDay ?? 0} kcal/day or ${perWeek ?? 0} kcal/week';
  static String challengeDayText(int dayNumber, int totalDays, double burned) =>
      'Day $dayNumber of $totalDays day challenge : ${burned.toStringAsFixed(2)} kcal burned';
  static String estimatedCaloriesBurned(int? perDay) =>
      'Estimated Calories Burned: ${perDay ?? 0} kcal/day';

  static String noExerciseAvailable = "No recommended exercise available";
  static String noTipsAvailable = "No fitness tips available";

  static String underweight = "Underweight";
  static String normal = "Normal";
  static String overweight = "Overweight";
  static String obese = "Obese";

  static String logoutConfirmation = "Are you sure you want to logout ?";
  static String logoutMsg = "Logout Failed, Please try again.";

  static String dashboard= "Dashboard";
  static String exerciseList = "Exercise List";
  static String profile = "Profile";
  static String bmiCalculator = "BMI Calculator";
  static String logout = "Logout";

  static String lblHeight = "Height (cm)";
  static String lblWeight = "Weight (kg)";
  static String lblBMI = "BMI";
  static String lblStatus = "Status";
}

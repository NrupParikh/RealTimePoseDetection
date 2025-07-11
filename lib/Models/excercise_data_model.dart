enum ExcerciseType { pushup, squat, plankToDownwardDog, jumpingJack, overHeadArmClap }

class ExcerciseDataModel {
  final String title;
  final ExcerciseType type;
  final String gifPath;

  // New fields for tips
  final String description;
  final String poseTip;
  final String startPosition;
  final String advantage;

  ExcerciseDataModel({
    required this.title,
    required this.type,
    required this.gifPath,
    required this.description,
    required this.poseTip,
    required this.startPosition,
    required this.advantage
  });
}

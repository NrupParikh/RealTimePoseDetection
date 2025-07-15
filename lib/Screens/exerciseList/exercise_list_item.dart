import 'package:flutter/material.dart';
import 'package:pose_detection/Components/exercise_info_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';

class ExerciseListItem extends StatelessWidget {
  final ExcerciseDataModel item;
  final Function(ExcerciseDataModel) onRequestPermissionsAndNavigate;

  const ExerciseListItem({
    super.key,
    required this.item,
    required this.onRequestPermissionsAndNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onRequestPermissionsAndNavigate(item),
      child: FrostedGlass(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        applyFilter: false,
        child: Row(
          children: [
            Image.asset(
              item.gifPath,
              fit: BoxFit.cover,
              width: 150,
              height: 100,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed:
                  () => ExerciseInfoDialog.showExerciseInfo(context, item),
            ),
          ],
        ),
      ),
    );
  }
}

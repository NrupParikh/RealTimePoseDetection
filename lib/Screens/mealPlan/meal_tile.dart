import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/page_name.dart';

class MealTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String>? items;

  const MealTile({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              items != null && items!.isNotEmpty
                  ? items!
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            print("Tag_recipe_for ${item}");
                            Get.toNamed(
                              PageName.recipe,
                              arguments: {"title": "${item}"},
                            );
                          },
                          child: Chip(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "$item",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                  : [
                    const Text(
                      "No data available",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
        ),
      ),
    );
  }
}

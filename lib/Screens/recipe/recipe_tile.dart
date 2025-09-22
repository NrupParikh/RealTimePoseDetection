import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';

class RecipeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String>? items;

  const RecipeTile({
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
                          child: Text(
                            "${AppStrings.bullet} $item",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
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

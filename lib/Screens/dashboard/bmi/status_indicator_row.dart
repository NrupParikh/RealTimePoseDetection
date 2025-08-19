import 'package:flutter/material.dart';

class StatusItem {
  final Color color;
  final String label;
  StatusItem({required this.color, required this.label});
}

class StatusIndicatorRow extends StatelessWidget {
  final List<StatusItem> statusItems;
  final double containerHeight;
  final TextStyle labelTextStyle;

  const StatusIndicatorRow({
    Key? key,
    required this.statusItems,
    this.containerHeight = 2,
    this.labelTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: statusItems.map((item) {
        return Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                height: containerHeight,
                color: item.color,
              ),
              Text(
                item.label,
                style: labelTextStyle,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
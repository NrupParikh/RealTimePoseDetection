
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pose_detection/api/apiModels/goal_status_history.dart';

class HistoryBarChart extends StatelessWidget {
  const HistoryBarChart({
    super.key,
    required this.goalHistoryList,
  });

  final List<GoalStatusHistory>? goalHistoryList;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        backgroundColor: Colors.transparent,
        maxY: 9000,
        groupsSpace: 40,
        barGroups:
            (goalHistoryList?.asMap().entries.map((
              entry,
            ) {
              int index = entry.key;
              var data = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: data.caloriesToBurn.toDouble(),
                    color: Colors.orangeAccent,
                    width: 10,
                    borderRadius: BorderRadius.zero,
                  ),
                  BarChartRodData(
                    toY: data.caloriesBurned.toDouble(),
                    color: Colors.greenAccent,
                    width: 10,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }).toList()) ??
            [],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  "G ${value.toInt() + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 &&
                    index < goalHistoryList!.length) {
                  final duration =
                      goalHistoryList?[index].goalDuration;
                  final durationAchieved =
                      goalHistoryList?[index]
                          .goalDurationAchieved;
                  return Text(
                    "${durationAchieved}/${duration}",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      ],
    );
  }
}

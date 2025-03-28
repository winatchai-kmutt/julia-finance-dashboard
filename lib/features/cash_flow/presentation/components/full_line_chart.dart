import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FullLineChart extends StatefulWidget {
  const FullLineChart({super.key});

  @override
  State<FullLineChart> createState() => _FullLineChartState();
}

class _FullLineChartState extends State<FullLineChart> {
  List<Color> gradientColors = [AppColors.tealDark, AppColors.redMuted];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }

  LineChartData mainData() {
    return LineChartData(
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: lineTouchData1,
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(reservedSize: 30, interval: 1),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(interval: 1, reservedSize: 42),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 5.5),
          ],
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  gradientColors
                      .map((color) => color.withValues(alpha: 0.2))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => AppColors.gray,
    ),
  );
}

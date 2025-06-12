import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoneyLineChart extends StatelessWidget {
  const MoneyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    const xLabels = ["01", "08", "16", "24", "28", "30", "31"];

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100000,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 5000),
              FlSpot(2, 1000),
              FlSpot(3, 3000),
              FlSpot(4, 100),
              FlSpot(5, 20000),
              FlSpot(6, 7000),
              FlSpot(7, 98500),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                int index = value.toInt() - 1;
                if (index >= 0 && index < xLabels.length) {
                  return Text(
                    xLabels[index],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink(); // Prevent crash
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20000,
              reservedSize: 50,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '₹${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}

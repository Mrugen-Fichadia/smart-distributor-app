import 'package:fl_chart/fl_chart.dart';

import '../imports.dart';
import '../utils/color_palette.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Palette.maroon,
            spots: const [
              FlSpot(1, 20),
              FlSpot(2, 10),
              FlSpot(3, 10),
              FlSpot(4, 7),
              FlSpot(5, 5),
              FlSpot(6, 5),
            ],
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

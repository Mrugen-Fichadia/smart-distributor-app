import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PaymentStatusChart extends StatefulWidget {
  const PaymentStatusChart({super.key});

  @override
  State<PaymentStatusChart> createState() => _PaymentStatusChartState();
}

class _PaymentStatusChartState extends State<PaymentStatusChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "label": "Paid",
        "value": 85.0,
        "amount": "₹85,000",
        "color": Colors.green,
      },
      {
        "label": "Unpaid",
        "value": 15.0,
        "amount": "₹15,000",
        "color": Colors.red,
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    touchedIndex =
                        response?.touchedSection?.touchedSectionIndex ?? -1;
                  });
                },
              ),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              sections: List.generate(data.length, (i) {
                final isTouched = i == touchedIndex;
                final item = data[i];
                return PieChartSectionData(
                  title: item['label'],
                  value: item['value'],
                  color: item['color'],
                  radius: isTouched ? 65 : 55,
                  showTitle: true,
                  titleStyle: TextStyle(
                    fontSize: isTouched ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (touchedIndex != -1)
          Text(
            "${data[touchedIndex]['label']} Collected: ${data[touchedIndex]['amount']}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }
}

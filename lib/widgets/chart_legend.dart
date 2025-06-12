import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartLegend extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ChartLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: item['color']),
            const SizedBox(width: 6),
            Text(item['label'], style: GoogleFonts.poppins(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

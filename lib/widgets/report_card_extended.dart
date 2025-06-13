import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';

class ReportCardExtended extends StatelessWidget {
  final String product, qty, rate, amount, inVal, outVal, paidQty;

  const ReportCardExtended({
    super.key,
    required this.product,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.inVal,
    required this.outVal,
    required this.paidQty,
  });

  @override
  Widget build(BuildContext context) {
    final totalQty = int.tryParse(qty) ?? 0;
    final paid = int.tryParse(paidQty) ?? 0;
    final unpaid = totalQty - paid;

    final status = (paid == totalQty) ? "Paid" : "Partially Paid";

    final statusColor = (paid == totalQty) ? Colors.green : Colors.orange;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primary.withAlpha(15)
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product: $product",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: primary,
              ),
            ),
            const SizedBox(height: 8),
            _buildRow("Quantity", qty),
            _buildRow("Rate", "₹$rate"),
            _buildRow("Amount", "₹$amount"),
            _buildRow("In / Out", "$inVal / $outVal"),
            _buildRow("Payment Status", status, valueColor: statusColor),
            if (paid == totalQty)
              _buildRow("Paid", "$paid")
            else
              _buildRow(
                "Paid / Not Paid",
                "$paid / $unpaid",
                valueColor: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

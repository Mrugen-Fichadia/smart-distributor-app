import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFService {
  static Future<void> generateReportFromData(
    List<Map<String, dynamic>> dataList,
  ) async {
    final pdf = pw.Document();

    // Dummy unpaid customer details
    final unpaidCustomers = [
      {'name': 'Ravi Kumar', 'product': '14.2KG Cylinder', 'amount': '1864'},
      {'name': 'Meena P', 'product': '5KG Cylinder', 'amount': '1266'},
    ];

    // Dummy new connections
    final newConnections = [
      {'name': 'Ravi Kumar', 'product': '19KG Cylinder', 'qty': '1'},
      {'name': 'Megha Singh', 'product': '14.2KG Cylinder', 'qty': '2'},
    ];

    // Dummy terminated connections
    final terminatedConnections = [
      {'name': 'Deepa S', 'product': '14.2KG Cylinder', 'qty': '2'},
      {'name': 'Rahul T', 'product': '5KG Cylinder', 'qty': '1'},
    ];

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "ANKIT GAS AGENCY",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Text(
                "PRODUCT SUMMARY",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Table.fromTextArray(
                headers: ['Product', 'Qty', 'Rate', 'Amount', 'In', 'Out'],
                data: dataList.map((item) {
                  return [
                    item['product'],
                    item['qty'],
                    item['rate'],
                    item['amount'],
                    item['in'],
                    item['out'],
                  ];
                }).toList(),
              ),

              if (newConnections.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  "New Connections",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Table.fromTextArray(
                  headers: ['Customer Name', 'Product', 'Quantity'],
                  data: newConnections
                      .map((e) => [e['name'], e['product'], e['qty']])
                      .toList(),
                ),
              ],

              if (terminatedConnections.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  "Terminated Connections",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Table.fromTextArray(
                  headers: ['Customer Name', 'Product', 'Quantity'],
                  data: terminatedConnections
                      .map((e) => [e['name'], e['product'], e['qty']])
                      .toList(),
                ),
              ],

              if (unpaidCustomers.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  "Unpaid Customers",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Table.fromTextArray(
                  headers: ['Customer Name', 'Product', 'Amount Unpaid'],
                  data: unpaidCustomers
                      .map((e) => [e['name'], e['product'], '${e['amount']}'])
                      .toList(),
                ),
              ],

              pw.SizedBox(height: 16),
              pw.Text(
                "Remaining Cylinders:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Bullet(text: "19KG: +3"),
              pw.Bullet(text: "14.2KG: -2"),
              pw.Bullet(text: "5KG: -1"),

              pw.SizedBox(height: 12),
              pw.Text("Report : Daily"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

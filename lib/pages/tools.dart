import 'package:flutter/material.dart';

class Tools extends StatefulWidget {
  const Tools({super.key});

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  final List<Map<String, dynamic>> tools = [
    {"title": "Add Customer", "icon": Icons.person_add},
    {"title": "Add Stock", "icon": null},
    {"title": "Quick Customer", "icon": null},
    {"title": "Daily Report", "icon": Icons.today},
    {"title": "Custom Report", "icon": Icons.insert_chart_outlined},
    {"title": "Add Hawker", "icon": Icons.delivery_dining},
    {"title": "Distribution Center", "icon": Icons.location_city},
    {"title": "Payment Status", "icon": Icons.payment},
    {"title": "TV In/Out", "icon": null},
    {"title": "HosePipe In/Out", "icon": null},
    {"title": "DRP In/Out", "icon": null},
    {"title": "HotPlate In/Out", "icon": null},
    {"title": "Delivery Details", "icon": Icons.local_shipping},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2),
            ),
            child: Icon(Icons.person, size: 24),
          ),
        ),
        title: Text("Tools", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: tools
              .map(
                (tool) =>
                    ToolCard(title: tool['title'], iconData: tool['icon']),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final IconData? iconData;

  const ToolCard({required this.title, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle action or navigation
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconData != null
                    ? Icon(iconData, size: 36, color: Colors.deepPurple)
                    : title == "TV In/Out"
                    ? Image.asset(
                        "assets/images/gas_cylinder.png",
                        color: Colors.deepPurple,
                        height: 35,
                      )
                    : title == "HosePipe In/Out"
                    ? Image.asset(
                        "assets/images/plumbing.png",
                        color: Colors.deepPurple,
                        height: 35,
                      )
                    : title == "DRP In/Out"
                    ? Image.asset(
                        "assets/images/regulator.png",
                        color: Colors.deepPurple,
                        height: 35,
                      )
                    : title == "Quick Customer"
                    ? Image.asset(
                        "assets/images/quick_customer.png",
                        color: Colors.deepPurple,
                        height: 35,
                      ) : title == "Add Stock"
                    ? Image.asset(
                        "assets/images/add_stock.png",
                        color: Colors.deepPurple,
                        height: 35,
                      )
                    : Image.asset(
                        "assets/images/gas-stove.png",
                        color: Colors.deepPurple,
                        height: 40,
                      ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

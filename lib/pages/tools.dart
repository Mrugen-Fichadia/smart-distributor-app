import 'package:flutter/material.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/cylinder_rate_page.dart';
import 'package:smart_distributor_app/pages/quick_customer.dart';
import 'package:smart_distributor_app/pages/tv-in-out.dart';
import 'package:smart_distributor_app/pages/hawker/hawker_list_page.dart';
import 'package:smart_distributor_app/pages/distribution_center/distribution_list_screen.dart';

class Tools extends StatefulWidget {
  const Tools({super.key});

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  final List<Map<String, dynamic>> tools = [
    {"title": "Add Customer", "icon": Icons.person_add},
    {"title": "Edit Rates", "icon": null, "page": CylinderRatePage()},
    {"title": "Add Stock", "icon": null},
    {"title": "Quick Customer", "icon": null, "page": QuickCustomerForm()},
    {"title": "Daily Report", "icon": Icons.today},
    {"title": "Custom Report", "icon": Icons.insert_chart_outlined},
    {
      "title": "Add Hawker",
      "icon": Icons.delivery_dining,
      "page": HawkerListPage(),
    },
    {"title": "Distribution Center", "icon": Icons.location_city, "page": DistributionCenterListPage()},
    {
      "title": "Add Worker",
      "icon": null,
    },
    {
      "title": "Add Manager",
      "icon": null,
    },
    {"title": "Payment Status", "icon": Icons.payment},
    {"title": "Customer Delivery", "icon": Icons.payment},
    {"title": "TV In/Out", "icon": null, "page": TvInOutPage()},
    {"title": "HosePipe Delivery", "icon": null},
    {"title": "DRP Delivery", "icon": null},
    {"title": "HotPlate Delivery", "icon": null},
    {"title": "Dispatch/ Return Log", "icon": Icons.local_shipping},
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
        title: Text("Tools", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                (tool) => ToolCard(
                  title: tool['title'],
                  iconData: tool['icon'],
                  page: tool['page'],
                ),
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
  final Widget? page;

  const ToolCard({required this.title, this.iconData, this.page});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page!),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconData != null
                    ? Icon(iconData, size: 36, color: primary)
                    : title == "TV In/Out"
                    ? Image.asset(
                        "assets/images/gas_cylinder.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "HosePipe Delivery"
                    ? Image.asset(
                        "assets/images/plumbing.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "DRP Delivery"
                    ? Image.asset(
                        "assets/images/regulator.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "Quick Customer"
                    ? Image.asset(
                        "assets/images/quick_customer.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "Edit Rates"
                    ? Image.asset(
                        "assets/images/rates.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "Add Stock"
                    ? Image.asset(
                        "assets/images/add_stock.png",
                        color: primary,
                        height: 35,
                      )
                    : title == "Add Manager"
                    ? Image.asset(
                        "assets/images/manager.png",
                        height: 35,
                      )
                    : title == "Add Worker"
                    ? Image.asset(
                        "assets/images/worker.png",
                        height: 35,
                      )
                    : Image.asset(
                        "assets/images/gas-stove.png",
                        color: primary,
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

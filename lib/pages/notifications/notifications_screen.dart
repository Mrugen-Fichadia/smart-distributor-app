import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/notifications/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // -------------- dummy list ----------------------//
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      message: 'Welcome !',
      description: 'this is description',
      timeAgo: '2 h',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      message: 'New message',
      description: 'description',
      timeAgo: '6 h',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      message: 'Your order is shipped',
      description: 'order ',
      timeAgo: '22 h',
      isRead: false,
    ),
    NotificationItem(
      id: '4',
      message: 'Get our new product ?',
      description: 'new produt.',
      timeAgo: '2 d',
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  //------------------- 3 tabs ------------------
  List<NotificationItem> _getNotificationsByType(String type) {
    switch (type) {
      case 'All':
        return notifications;
      case 'Unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'Read':
        return notifications.where((n) => n.isRead).toList();
      default:
        return [];
    }
  }

  void _markNotificationAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark All Read',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
          labelColor: primary,
          unselectedLabelColor: const Color.fromARGB(179, 71, 71, 71),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList('All'),
          _buildNotificationList('Unread'),
          _buildNotificationList('Read'),
        ],
      ),
    );
  }

  Widget _buildNotificationList(String type) {
    List<NotificationItem> filteredNotifications = _getNotificationsByType(
      type,
    );

    if (filteredNotifications.isEmpty && type == 'Unread') {
      return Center(
        child: Text(
          'Nothing here!',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        NotificationItem notification = filteredNotifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: notification.isRead
              ? const Color.fromARGB(255, 255, 232, 230)
              : const Color.fromARGB(255, 255, 190, 180),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -----------------  leading icon for unread only------------------
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),

            // -----------------  title ----------------------
            title: Text(
              notification.message,
              style: TextStyle(
                fontWeight: notification.isRead
                    ? FontWeight.normal
                    : FontWeight.bold,
                fontSize: 18,
                color: Colors.black,

                // color: notification.isRead ? Colors.black : Colors.black54,
              ),
            ),

            // -----------------  description  ----------------------
            subtitle: Text(
              notification.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,

                // color: notification.isRead ? Colors.grey[800] : Colors.grey,
              ),
            ),

            // -----------------  time  ----------------------
            trailing: Text(
              notification.timeAgo,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                // color: notification.isRead
                //   ? Colors.grey[800]
                //   : Colors.grey,
              ),
            ),
            onTap: () {
              if (!notification.isRead) {
                _markNotificationAsRead(notification);
              }
            },
          ),
        );
      },
    );
  }
}

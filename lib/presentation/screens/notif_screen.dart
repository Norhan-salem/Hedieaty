import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';

import '../../data/services/notif_storage_service.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await NotificationStorageService.getNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

  Future<void> _clearNotifications() async {
    await NotificationStorageService.clearNotifications();
    setState(() {
      _notifications = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        onActionPressed: _clearNotifications,
        actionIcon: Icons.delete_outline,
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _notifications.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.darkTeal,
                      ),
                    ),
                  )
                : Column(
                    children: _notifications.map((notification) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: ColorPalette.darkTeal, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            notification,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.darkTeal),
                          ),
                          tileColor: ColorPalette.yellowHighlight,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ),
    );
  }
}

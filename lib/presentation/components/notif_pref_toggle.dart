import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';

class NotifToggle extends StatefulWidget {
  final bool initialStatus;
  final Function(bool) onStatusChanged;

  NotifToggle({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _NotifToggleState createState() => _NotifToggleState();
}

class _NotifToggleState extends State<NotifToggle> {
  late bool _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  void _toggleStatus() {
    setState(() {
      _currentStatus = !_currentStatus; // Toggle between true/false
      widget.onStatusChanged(_currentStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerHeight = screenHeight * 0.07;
    double containerWidth = screenWidth * 0.7;

    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: ColorPalette.eggShell,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorPalette.darkCyan, width: 2),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.darkCyan.withOpacity(1),
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${_currentStatus ? 'Notification' : 'No Notifications'}',
            style: TextStyle(
              color: ColorPalette.darkCyan,
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.04,
            ),
          ),
          Switch(
            activeColor: ColorPalette.eggShell,
            inactiveThumbColor: ColorPalette.darkCyan,
            activeTrackColor: ColorPalette.darkCyan,
            inactiveTrackColor: ColorPalette.eggShell,
            value: _currentStatus,
            onChanged: (value) => _toggleStatus(),
          ),
        ],
      ),
    );
  }
}

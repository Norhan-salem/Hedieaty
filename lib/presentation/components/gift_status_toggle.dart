import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';
import 'package:hedieaty_flutter_application/data/services/gift_service.dart';
import 'package:hedieaty_flutter_application/domain/enums/GiftStatus.dart';

class GiftStatusToggle extends StatefulWidget {
  final GiftStatus initialStatus;
  final Function(GiftStatus) onStatusChanged;

  GiftStatusToggle({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _GiftStatusToggleState createState() => _GiftStatusToggleState();
}

class _GiftStatusToggleState extends State<GiftStatusToggle> {
  late GiftStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  void _toggleStatus() {
    setState(() {
      _currentStatus = _currentStatus == GiftStatus.available ? GiftStatus.pledged : GiftStatus.available;
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
            'Status: ${mapGiftStatusToString(_currentStatus)}',
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
            value: _currentStatus == GiftStatus.pledged,
            onChanged: (value) => _toggleStatus(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GiftStatusToggle extends StatefulWidget {
  final String initialStatus;
  final Function(String) onStatusChanged;

  GiftStatusToggle({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _GiftStatusToggleState createState() => _GiftStatusToggleState();
}

class _GiftStatusToggleState extends State<GiftStatusToggle> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  void _toggleStatus() {
    setState(() {
      _currentStatus = _currentStatus == 'Available' ? 'Pledged' : 'Available';
      widget.onStatusChanged(_currentStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Status: $_currentStatus'),
        Switch(
          value: _currentStatus == 'Pledged',
          onChanged: (value) => _toggleStatus(),
        ),
      ],
    );
  }
}

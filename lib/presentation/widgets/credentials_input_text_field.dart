import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';

class InputTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final Function(String)? onChanged;
  final bool obscureText;
  final VoidCallback? togglePasswordView;
  final IconData leadingIcon;
  final String? errorText;

  const InputTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.onChanged,
    this.obscureText = false,
    this.togglePasswordView,
    required this.leadingIcon,
    this.errorText,
  }) : super(key: key);

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late FocusNode _focusNode;
  Color _fillColor = Colors.white.withOpacity(0.8);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _fillColor = _focusNode.hasFocus ? Colors.white : Colors.white.withOpacity(0.8);
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isLandscape = screenWidth > screenHeight;

    final double fontSize = screenWidth < 360 ? 14.0 : 16.0;
    final double iconSize = screenWidth < 360 ? 20.0 : 24.0;

    return Center(
      child: Container(
        width: isLandscape ? screenWidth * 0.7 : double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: Colors.teal.withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontSize: fontSize,
                ),
                prefixIcon: Icon(
                  widget.leadingIcon,
                  color: ColorPalette.darkCyan,
                  size: iconSize,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: ColorPalette.darkCyan,
                    size: iconSize,
                  ),
                  onPressed: widget.togglePasswordView,
                )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette.darkCyan,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette.darkCyan,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.darkPink, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: _fillColor,
                errorText: widget.errorText,
                errorStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: ColorPalette.darkPink,
                  fontSize: fontSize * 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

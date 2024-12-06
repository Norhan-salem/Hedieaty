import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';
import '../../core/utils/registration_input_validation.dart';
import '../../data/repositories/friend_repository.dart';

class FriendFormDialog extends StatefulWidget {
  final String currentUserId;

  const FriendFormDialog({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _FriendFormState createState() => _FriendFormState();
}

class _FriendFormState extends State<FriendFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Friend Email',
                labelStyle: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
                floatingLabelStyle: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.darkCyan, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.darkTeal, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.darkPink, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorStyle: TextStyle(
                  color: ColorPalette.darkPink,
                  fontFamily: 'Poppins',
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegistrationInputValidation.isEmailValid(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: ColorPalette.darkPink,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox.square(
          dimension: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              String friendEmail = _emailController.text;
              try {
                final success = await FriendRepository().addFriendByEmail(
                  widget.currentUserId,
                  friendEmail,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend added successfully!')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorPalette.eggShell,
            backgroundColor: ColorPalette.darkCyan,
            side: BorderSide(color: ColorPalette.darkTeal, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Add', style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/gift_details_tile.dart';
import 'package:hedieaty_flutter_application/presentation/components/img_upload.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';

import '../../core/constants/color_palette.dart';
import '../../core/usecases/build_event_tile.dart';
import '../../data/models/user_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_circle_avatar.dart';
import 'my_pledged_gifts_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final VoidCallback onManageNotifications;
  final VoidCallback onEditProfile;

  ProfileScreen({
    Key? key,
    required this.user,
    required this.onManageNotifications,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? selectedImage;
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.userName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_isEditing) ...[
                      ImagePickerWidget(
                        onImageSelected: (image) {
                          setState(() {
                            selectedImage = image;
                          });
                        },
                      ),
                      // m7tageen yt8yyro tb3n
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                      ),
                    ] else ...[
                      // profilepic should be changed here as well
                      CustomCircleAvatar(
                        imageUrl: 'assets/images/profile_mock.png',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      GiftDetailsTile(text: _nameController.text),
                      GiftDetailsTile(text: _emailController.text),
                      GiftDetailsTile(text: _phoneController.text),
                    ],
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'My Events and Gifts',
                      style: TextStyle(
                        fontFamily: 'Rowdies',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.darkTeal,
                      ),
                    ),
                    ...widget.user.createdEvents
                        .map((event) => buildEventTile(context, event))
                        .toList(),
                    SizedBox(height: screenHeight * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPledgedGiftsScreen(
                              pledgedGifts: [
                                PledgedGift(
                                    giftName: 'Book',
                                    friendName: 'Alice',
                                    dueDate:
                                        DateTime.now().add(Duration(days: 7)),
                                    isPending: true),
                                PledgedGift(
                                    giftName: 'Watch',
                                    friendName: 'Bob',
                                    dueDate: DateTime.now()
                                        .subtract(Duration(days: 1)),
                                    isPending: false),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.69,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorPalette.eggShell,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorPalette.darkCyan,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.darkCyan.withOpacity(1),
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'View My Pledged Gifts',
                          style: TextStyle(
                            fontFamily: 'Rowdies',
                            color: ColorPalette.darkCyan,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    CreateEventButton(
                      buttonText: _isEditing ? 'Save Changes' : 'Edit Profile',
                      onPressed: () {
                        if (_isEditing) {
                          _toggleEdit();
                        } else {
                          _toggleEdit();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

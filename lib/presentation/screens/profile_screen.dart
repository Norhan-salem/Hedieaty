import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/img_upload.dart';
import 'package:hedieaty_flutter_application/presentation/components/notif_pref_toggle.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';

import '../../core/constants/color_palette.dart';
import '../../core/usecases/build_event_tile.dart';
import '../../data/models/event_model.dart';
import '../../data/models/gift_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/gift_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/img_storage_service.dart';
import '../../data/services/notif_preference_service.dart';
import '../components/gift_details_tile.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_circle_avatar.dart';
import 'my_pledged_gifts_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onManageNotifications;
  final VoidCallback onEditProfile;

  ProfileScreen({
    Key? key,
    required this.userId,
    required this.onManageNotifications,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EventRepository _eventRepository = EventRepository();
  final GiftRepository _giftRepository = GiftRepository();
  final NotifPreferencesService _notifPreferencesService =
  NotifPreferencesService();

  bool _isEditing = false;
  bool _notificationsEnabled = true;
  String? selectedImage;
  List<Event> userEvents = [];
  Map<int, List<Gift>> eventGifts = {};

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _profileImgPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    await _fetchUserDetails();
    await _fetchUserEventsAndGifts();
    await _loadNotificationPreference();
  }

  Future<void> _updateProfileField(String field, dynamic newValue) async {
    try {
      await UserRepository().updateUserField(widget.userId, field, newValue);
    } catch (e) {
      print('Error updating $field: $e');
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? currentUser = await UserRepository().fetchCurrentUser();
      if (currentUser != null) {
        setState(() {
          _nameController.text = currentUser.username;
          _emailController.text = currentUser.email;
          _phoneController.text = currentUser.phoneNumber;
          _profileImgPath = currentUser.profileImagePath;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _fetchUserEventsAndGifts() async {
    try {
      List<Event> events =
      await _eventRepository.fetchUserEvents(widget.userId);
      Map<int, List<Gift>> giftsMap = {};
      for (Event event in events) {
        List<Gift> gifts = await _giftRepository.fetchGiftsByEventId(event.id!);
        giftsMap[event.id!] = gifts;
      }
      setState(() {
        userEvents = events;
        eventGifts = giftsMap;
      });
    } catch (e) {
      print('Error fetching user events or gifts: $e');
    }
  }

  Future<void> _loadNotificationPreference() async {
    bool isEnabled = await _notifPreferencesService.getNotificationPreference();
    setState(() {
      _notificationsEnabled = isEnabled;
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _notifPreferencesService.setNotificationPreference(value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<String?> _uploadProfileImage() async {
    if (selectedImage != null) {
      final imageFile = File(selectedImage!);
      try {
        final imageUrl = await uploadToImgBB(imageFile);
        return imageUrl;
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
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
                      DetailsTextField(
                          controller: _nameController, labelText: 'Name'),
                      DetailsTextField(
                        controller: _emailController,
                        labelText: 'Email',
                      ),
                      DetailsTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      NotifToggle(
                        initialStatus: _notificationsEnabled,
                        onStatusChanged: _toggleNotifications,
                      ),
                    ] else ...[
                      CustomCircleAvatar(imageUrl: _profileImgPath),
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
                    ...userEvents.map((event) {
                      return BuildEventTile(
                        event: event,
                        gifts: eventGifts[event.id] ?? [],
                      );
                    }).toList(),
                    SizedBox(height: screenHeight * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPledgedGiftsScreen(
                              pledgedGifts: _giftRepository
                                  .fetchPledgedGiftsByUserId(widget.userId),
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
                      onPressed: () async {
                        if (_isEditing) {
                          _toggleEdit();
                          if (_nameController.text.isNotEmpty) {
                            await _updateProfileField(
                                'username', _nameController.text);
                          }
                          if (_emailController.text.isNotEmpty) {
                            await _updateProfileField(
                                'email', _emailController.text);
                          }
                          if (_phoneController.text.isNotEmpty) {
                            await _updateProfileField(
                                'phone_number', _phoneController.text);
                          }
                          if (selectedImage != null) {
                            String? imagePath = await _uploadProfileImage();
                            if (imagePath != null) {
                              await _updateProfileField(
                                  'profile_image_path', imagePath);
                            }
                          }
                          await _notifPreferencesService
                              .setNotificationPreference(_notificationsEnabled);
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


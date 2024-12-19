import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_app_bar.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';

import '../../data/models/gift_model.dart';
import '../../data/repositories/gift_repository.dart';
import '../../data/services/gift_service.dart';
import '../../data/services/img_storage_service.dart';
import '../../domain/enums/GiftCategory.dart';
import '../../domain/enums/GiftStatus.dart';
import '../components/custom_dropdown_list.dart';
import '../components/gift_status_toggle.dart';
import '../components/img_upload.dart';

class AddGiftScreen extends StatefulWidget {
  final int eventId;
  final Gift? gift;

  AddGiftScreen({Key? key, required this.eventId, this.gift}) : super(key: key);

  @override
  _AddGiftScreenState createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final _addGiftFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  GiftCategory? category;
  GiftStatus? giftStatus;
  String? selectedImage;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.gift?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.gift?.description ?? '');
    priceController = TextEditingController(
        text: widget.gift != null ? widget.gift!.price.toString() : '');
    category =
        widget.gift != null ? GiftCategory.values[widget.gift!.category] : null;
    giftStatus = widget.gift != null
        ? GiftStatus.values[widget.gift!.status]
        : GiftStatus.available;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> publishGift() async {
    try {
      if (_addGiftFormKey.currentState!.validate()) {
        String? imageUrl;
        if (selectedImage != null) {
          imageUrl = await uploadToImgBB(File(selectedImage!));
          if (imageUrl == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Failed to upload the image. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }
        } else {
          imageUrl = widget.gift?.giftImagePath ??
              'https://i.ibb.co/QFnzXZH/gift-default-img.png';
        }

        final newGift = Gift(
          id: widget.gift?.id ?? generateUniqueId(),
          name: nameController.text,
          giftImagePath: imageUrl,
          description: descriptionController.text,
          category: category?.index ?? 0,
          price: double.parse(priceController.text),
          status: giftStatus?.index ?? 0,
          eventId: widget.eventId,
          pledged_by_user_id: widget.gift?.pledged_by_user_id ?? '',
          isDeleted: widget.gift?.isDeleted ?? false,
          isPublished: true,
        );

        if (widget.gift == null) {
          await GiftRepository().createGift(newGift);
        } else {
          final updateFields = {
            'name': newGift.name,
            'description': newGift.description,
            'price': newGift.price,
            'category': newGift.category,
            'status': newGift.status,
            'pledged_by_user_id': newGift.pledged_by_user_id,
            'isPublished': true,
            'gift_image_path': newGift.giftImagePath,
          };
          await GiftRepository().updateGift(newGift.id, updateFields);
        }

        await GiftRepository().publishGiftToFirestore(newGift);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Gift published successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to publish the gift. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> saveGift() async {
    try {
      if (_addGiftFormKey.currentState!.validate()) {
        String? imageUrl;

        if (selectedImage != null) {
          imageUrl = await uploadToImgBB(File(selectedImage!));
          if (imageUrl == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Failed to upload the image. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }
        } else {
          imageUrl = widget.gift?.giftImagePath ??
              'https://i.ibb.co/QFnzXZH/gift-default-img.png';
        }

        final newGift = Gift(
          id: widget.gift?.id ?? generateUniqueId(),
          name: nameController.text,
          giftImagePath: imageUrl,
          description: descriptionController.text,
          category: category?.index ?? 0,
          price: double.parse(priceController.text),
          status: giftStatus?.index ?? 0,
          eventId: widget.eventId,
          pledged_by_user_id: widget.gift?.pledged_by_user_id ?? '',
          isDeleted: widget.gift?.isDeleted ?? false,
          isPublished: widget.gift?.isPublished ?? false,
        );
        if (widget.gift == null) {
          await GiftRepository().createGift(newGift);
        } else {
          final updateFields = {
            'name': newGift.name,
            'description': newGift.description,
            'price': newGift.price,
            'category': newGift.category,
            'status': newGift.status,
            'pledged_by_user_id': newGift.pledged_by_user_id,
            'isPublished': newGift.isPublished,
            'gift_image_path': newGift.giftImagePath,
          };
          await GiftRepository().updateGift(newGift.id, updateFields);
        }
        Navigator.pop(context, newGift);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save the gift. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.07;

    return Scaffold(
      appBar:
          CustomAppBar(title: widget.gift == null ? 'Add Gift' : 'Edit Gift'),
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Form(
                key: _addGiftFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ImagePickerWidget(
                        initialImagePath: widget.gift?.giftImagePath,
                        onImageSelected: (image) {
                          setState(() {
                            selectedImage = image;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DetailsTextField(
                        controller: nameController,
                        labelText: 'Gift Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      DetailsTextField(
                        controller: descriptionController,
                        labelText: 'Description',
                      ),
                      CustomDropdownButton(
                        category: category != null
                            ? mapGiftCategoryToString(category!)
                            : null,
                        items: GiftCategory.values
                            .map((e) => mapGiftCategoryToString(e))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            category = GiftCategory.values.firstWhere(
                              (e) => mapGiftCategoryToString(e) == value,
                            );
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select a category' : null,
                      ),
                      DetailsTextField(
                        controller: priceController,
                        labelText: 'Price (USD)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          final parsedValue = double.tryParse(value);
                          if (parsedValue == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      GiftStatusToggle(
                        initialStatus:
                            widget.gift?.giftStatus ?? GiftStatus.available,
                        onStatusChanged: (status) {
                          setState(() {
                            giftStatus = status;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CreateEventButton(
                        onPressed: saveGift,
                        buttonText:
                            widget.gift == null ? 'Add Gift' : 'Save Changes',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CreateEventButton(
                        onPressed: publishGift,
                        buttonText: 'Publish Gift',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

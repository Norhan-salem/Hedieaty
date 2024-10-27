import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImagePath;
  final Function(File?) onImageSelected;

  const ImagePickerWidget({
    Key? key,
    this.initialImagePath,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double avatarRadius = screenWidth * 0.25;
    double uploadButtonSize = screenWidth * 0.1;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.darkTeal,
          borderRadius: BorderRadius.circular(avatarRadius),
          border: Border.all(color: ColorPalette.darkTeal, width: 2),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.darkTeal.withOpacity(1),
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : const AssetImage('assets/images/gift_default_img.png')
                  as ImageProvider,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: uploadButtonSize,
              height: uploadButtonSize,
              decoration: BoxDecoration(
                color: ColorPalette.darkCyan,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorPalette.darkTeal, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.darkTeal.withOpacity(1),
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: IconButton(
                iconSize: uploadButtonSize * 0.5,
                icon: Icon(Icons.file_upload_outlined),
                color: ColorPalette.eggShell,
                onPressed: () {
                  _pickImage();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

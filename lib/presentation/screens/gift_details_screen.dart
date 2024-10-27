import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/gift_details_tile.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_circle_avatar.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/gift_model.dart';
import '../widgets/custom_app_bar.dart';

class GiftDetailsScreen extends StatelessWidget {
  final Gift gift;

  const GiftDetailsScreen({Key? key, required this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: gift.name),
      body: Stack(
        children: [
          BackgroundContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCircleAvatar(
                    imageUrl: gift.imageURL,
                  ),
                  SizedBox(height: 16),
                  GiftDetailsTile(text: 'Name: ${gift.name}'),
                  SizedBox(height: 8),
                  GiftDetailsTile(
                    text: '${gift.description}',
                    height: screenHeight * 0.25,
                  ),
                  SizedBox(height: 8),
                  GiftDetailsTile(text: 'Category: ${gift.category}'),
                  SizedBox(height: 8),
                  GiftDetailsTile(text: 'Price: ${gift.price} USD'),
                  SizedBox(height: 8),
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.77,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorPalette.eggShell,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: gift.status.toLowerCase() == 'available'
                            ? ColorPalette.darkCyan
                            : ColorPalette.darkPink,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gift.status.toLowerCase() == 'available'
                              ? ColorPalette.darkCyan.withOpacity(1)
                              : ColorPalette.darkPink.withOpacity(1),
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      gift.status,
                      style: TextStyle(
                        color: gift.status.toLowerCase() == 'available'
                            ? ColorPalette.darkCyan
                            : ColorPalette.darkPink,
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

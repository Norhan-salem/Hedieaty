import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_app_bar.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';

import '../../data/models/gift_model.dart';
import '../components/custom_dropdown_list.dart';
import '../components/gift_status_toggle.dart';

class AddGiftScreen extends StatefulWidget {
  final Gift? gift;

  const AddGiftScreen({Key? key, this.gift}) : super(key: key);

  @override
  _AddGiftScreenState createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final _addGiftFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? category;
  late String giftStatus;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.gift?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.gift?.description ?? '');
    priceController =
        TextEditingController(text: widget.gift?.price.toString() ?? '');
    category = widget.gift?.category;
    giftStatus = widget.gift?.status ?? 'Available';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.04;

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
                      DetailsTextField(
                        controller: nameController,
                        labelText: 'Gift Name',
                      ),
                      DetailsTextField(
                        controller: descriptionController,
                        labelText: 'Description',
                      ),
                      CustomDropdownButton(
                        category: category,
                        items: [
                          'Electronics',
                          'Fashion and Accessories',
                          'Home and Kitchen',
                          'Books and Stationery',
                          'Toys and Games',
                          'Sports and Outdoors',
                          'Beauty and Health',
                          'Food and Beverages',
                          'Experiences and Subscriptions',
                          'Art and Craft Supplies',
                          'Personalized Gifts',
                          'Pet Supplies',
                          'Gift Cards and Vouchers',
                          'Other'
                        ],
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select a category' : null,
                      ),
                      DetailsTextField(
                        controller: priceController,
                        labelText: 'Price',
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
                        initialStatus: giftStatus,
                        onStatusChanged: (status) {
                          setState(() {
                            giftStatus = status;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CreateEventButton(
                        onPressed: () {
                          if (_addGiftFormKey.currentState!.validate()) {
                            final newGift = Gift(
                              name: nameController.text,
                              description: descriptionController.text,
                              category: category ?? 'Other',
                              status: giftStatus,
                              price: double.parse(priceController.text),
                            );

                            Navigator.pop(context, newGift);
                          }
                        },
                        buttonText:
                            widget.gift == null ? 'Add Gift' : 'Save Changes',
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
}

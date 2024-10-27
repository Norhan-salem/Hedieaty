import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_app_bar.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';

import '../../data/models/event_model.dart';
import '../components/custom_dropdown_list.dart';
import '../components/date_selector.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;

  const AddEventScreen({Key? key, this.event}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _addEventFormKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late ValueNotifier<DateTime?> selectedDateNotifier;
  String? category;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.event?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    locationController =
        TextEditingController(text: widget.event?.location ?? '');
    selectedDateNotifier = ValueNotifier(widget.event?.date);
    category = widget.event?.category;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    selectedDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.07;

    return Scaffold(
      appBar: CustomAppBar(
          title: widget.event == null ? 'Add Event' : 'Edit Event'),
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Form(
                key: _addEventFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DetailsTextField(
                        controller: nameController,
                        labelText: 'Event Name',
                      ),
                      DetailsTextField(
                        controller: descriptionController,
                        labelText: 'Description',
                      ),
                      DetailsTextField(
                        controller: locationController,
                        labelText: 'Location',
                      ),
                      CustomDropdownButton(
                        category: category,
                        items: [
                          'Celebration',
                          'Work',
                          'Entertainment',
                          'Other'
                        ],
                        onChanged: (value) {
                          setState(() {
                            category = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select a category' : null,
                      ),
                      DateSelector(selectedDateNotifier: selectedDateNotifier),
                      SizedBox(height: screenHeight * 0.02),
                      CreateEventButton(
                        onPressed: () {
                          if (_addEventFormKey.currentState!.validate()) {
                            final newEvent = Event(
                              name: nameController.text,
                              description: descriptionController.text,
                              category: category ?? 'Other',
                              location: locationController.text,
                              date: selectedDateNotifier.value ??
                                  DateTime.now().add(Duration(days: 1)),
                              status: 'Upcoming',
                            );

                            Navigator.pop(context, newEvent);
                          }
                        },
                        buttonText:
                            widget.event == null ? 'Add Event' : 'Save Changes',
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

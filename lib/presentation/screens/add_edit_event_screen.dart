import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_app_bar.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';
import '../../data/models/event_model.dart';
import '../components/date_selector.dart';
import '../components/event_dropdown_list.dart';

class AddEventScreen extends StatelessWidget {
  final Event? event;

  AddEventScreen({Key? key, this.event}) : super(key: key);

  final _addEventFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController(text: event?.name ?? '');
    final TextEditingController descriptionController =
    TextEditingController(text: event?.description ?? '');
    final TextEditingController locationController =
    TextEditingController(text: event?.location ?? '');
    final ValueNotifier<DateTime?> selectedDateNotifier =
    ValueNotifier(event?.date);

    String? category = event?.category;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.04;

    return Scaffold(
      appBar: CustomAppBar(title: event == null ? 'Add Event' : 'Edit Event'),
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
                      EventDropdownButton(
                        category: category,
                        items: [
                          'Celebration',
                          'Work',
                          'Entertainment',
                          'Other'
                        ],
                        onChanged: (value) {
                          category = value!;
                        },
                        validator: (value) =>
                        value == null ? 'Select a category' : null,
                      ),
                      DetailsTextField(
                        controller: locationController,
                        labelText: 'Location',
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
                        event == null ? 'Add Event' : 'Save Changes',
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



import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/repositories/user_repository.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/custom_app_bar.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/details_input_text_field.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/services/event_service.dart';
import '../../domain/enums/EventCategory.dart';
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
  EventCategory? category;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    locationController =
        TextEditingController(text: widget.event?.location ?? '');
    selectedDateNotifier = ValueNotifier(
      widget.event != null ? DateTime.parse(widget.event!.date) : null,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    selectedDateNotifier.dispose();
    super.dispose();
  }

  Future<void> saveEvent() async {
    if (_addEventFormKey.currentState!.validate()) {
      try {
        final currentUser = await UserRepository().fetchCurrentUser();
        if (currentUser == null) {
          throw Exception("No logged-in user found");
        }

        final newEvent = Event(
          id: widget.event?.id ?? generateUniqueId(),
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          location: locationController.text.trim(),
          date: (selectedDateNotifier.value ??
                  DateTime.now().add(Duration(days: 1)))
              .toIso8601String(),
          category: category?.index ?? 0,
          userId: currentUser.id,
          isDeleted: widget.event?.isDeleted ?? false,
        );
        if (widget.event == null) {
          await EventRepository().createEvent(newEvent);
        } else {
          final updateFields = {
            'name': newEvent.name,
            'description': newEvent.description,
            'location': newEvent.location,
            'date': newEvent.date,
            'category': newEvent.category,
          };
          await EventRepository().updateEvent(newEvent.id, updateFields);
        }
        Navigator.pop(context, newEvent);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save the event. Please try again.'),
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
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.07;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.event == null ? 'Add New Event' : 'Edit Event',
      ),
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
                        category: category != null
                            ? mapEventCategoryToString(category!)
                            : null,
                        items: EventCategory.values
                            .map((e) => mapEventCategoryToString(e))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            category = EventCategory.values.firstWhere(
                              (e) => mapEventCategoryToString(e) == value,
                            );
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select a category' : null,
                      ),
                      DateSelector(selectedDateNotifier: selectedDateNotifier),
                      SizedBox(height: screenHeight * 0.02),
                      CreateEventButton(
                        key: Key('Add Event'),
                        onPressed: saveEvent,
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

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

extension StringExtensions on String {
  String capitalize() =>
      this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
}

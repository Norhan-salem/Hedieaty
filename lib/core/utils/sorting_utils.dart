import 'package:flutter/foundation.dart';
import '../../data/models/event_model.dart';
import '../../data/models/gift_model.dart';

void sortItems<T>(
    List<T> items, String option, ValueNotifier<List<T>> sortedItemsNotifier) {
  List<T> sortedItems = List.from(items);

  if (T == Event) {
    if (option == 'Name') {
      sortedItems
          .sort((a, b) => (a as Event).name.compareTo((b as Event).name));
    } else if (option == 'Category') {
      sortedItems.sort(
          (a, b) => (a as Event).category.compareTo((b as Event).category));
    } else if (option == 'Status') {
      Map<String, int> statusOrder = {
        'Upcoming': 0,
        'Current': 1,
        'Past': 2,
      };
      sortedItems.sort((a, b) => statusOrder[(a as Event).status]!
          .compareTo(statusOrder[(b as Event).status]!));
    }
  } else if (T == Gift) {
    if (option == 'Name') {
      sortedItems.sort((a, b) => (a as Gift).name.compareTo((b as Gift).name));
    } else if (option == 'Category') {
      sortedItems
          .sort((a, b) => (a as Gift).category.compareTo((b as Gift).category));
    } else if (option == 'Status') {
      Map<String, int> statusOrder = {
        'Available': 0,
        'Pledged': 1,
      };
      sortedItems.sort((a, b) => statusOrder[(a as Gift).status]!
          .compareTo(statusOrder[(b as Gift).status]!));
    }
  }

  sortedItemsNotifier.value = sortedItems;
}

import '../../domain/enums/GiftCategory.dart';
import '../../domain/enums/GiftStatus.dart';

String mapGiftCategoryToString(GiftCategory category){
  return category.name[0].toUpperCase() + category.name.substring(1);
}

String mapGiftStatusToString(GiftStatus status) {
  return status.name[0].toUpperCase() + status.name.substring(1);
}
import 'package:hedieaty_flutter_application/data/repositories/gift_repository.dart';
import 'package:hedieaty_flutter_application/data/repositories/user_repository.dart';

import '../../data/models/gift_model.dart';
import '../enums/GiftStatus.dart';

class GiftPledgeManager {
  final GiftRepository _giftRepository = GiftRepository();
  final UserRepository _userRepository = UserRepository();

  bool canPledgeGift(Gift gift) {
    return gift.status == GiftStatus.available.index;
  }

  Future<bool> pledgeGift(Gift gift) async {
    try {
      if (!canPledgeGift(gift)) {
        throw Exception('Gift is not available for pledging.');
      }
      final user = await _userRepository.fetchCurrentUser();
      final rowsUpdated = await _giftRepository.pledgeGift(gift.id, user!.id);

      if (rowsUpdated > 0) {
        print('Gift pledged successfully.');
        return true;
      } else {
        print('Failed to pledge the gift. It may have been modified or deleted.');
        return false;
      }
    } catch (e) {
      print('Error while pledging gift: $e');
      return false;
    }
  }
}

import '../../data/models/gift_model.dart';

class GiftPledgeManager {
  bool canPledgeGift(Gift gift) {
    return gift.status != 1;
  }

  void pledgeGift(Gift gift) {
    if (canPledgeGift(gift)) {
      gift.status = 1;
    }
  }
}

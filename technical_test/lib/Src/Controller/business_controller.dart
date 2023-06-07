import 'package:get/get.dart';

import '../Model/business_model.dart';

class BusinessController extends GetxController {
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt currentPageViewItemIndicator = 0.obs;
  RxList<Business> favoriteBusinessList = <Business>[].obs;
  RxDouble totalPrice = 0.0.obs;

  switchBetweenBottomNavigationItems(int currentIndex) {
    currentBottomNavItemIndex.value = currentIndex;
  }

  switchBetweenPageViewItems(int currentIndex) {
    currentPageViewItemIndicator.value = currentIndex;
  }

  // isFavoriteBusiness(Business business) {
  //   business.isFavorite = !business.isFavorite;
  //   update();
  //   if (business.isFavorite) {
  //     favoriteBusinessList.add(business);
  //   }
  //   if (!business.isFavorite) {
  //     favoriteBusinessList.removeWhere((element) => element == business);
  //   }
  // }

}

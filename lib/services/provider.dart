import 'dart:ui';

import 'package:get/get.dart';

import '../backend/models/user.dart';
import '../tools/tools.dart';

class Provider extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isSideBarOpen = true.obs;
  Rx<User> user = User(name: "Guest", color: getRandomHighContrastColor()).obs;

  //settings
  RxBool isDark = false.obs;
  RxString language = 'en'.obs;

  //quick
  RxString newSelectedStoragePath = ''.obs;






  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }
  void setIsDark(bool value) {
    isDark.value = value;
  }
  void toggleSideBar() {
    isSideBarOpen.value = !isSideBarOpen.value;
  }

  void setIsSideBarOpen(bool value){
    isSideBarOpen.value = value;

  }
  //user
  void setUser(User value) => user.value = value;
  void setUserName(String name) => user.value = user.value.copyWith(name: name);
  void setUserColor(Color color) => user.value = user.value.copyWith(color: color);
  //settings
  void setLanguage(String value) => language.value = value;

}

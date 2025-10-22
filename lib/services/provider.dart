import 'dart:ui';

import 'package:get/get.dart';

import '../backend/models/userMeta.dart';
import '../tools/tools.dart';

class Provider extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isSideBarOpen = true.obs;
  Rx<UserMeta> user = UserMeta(name: "Guest", color: getRandomHighContrastColor()).obs;

  //settings
  RxBool isDark = false.obs;
  RxBool isAutoSync = false.obs;
  RxBool isOfflineMode = false.obs;
  RxInt downloadLimit = (-1).obs; // -1=unlimited & 500 means 500kb
  RxInt uploadLimit = (-1).obs; // -1=unlimited & 500 means 500kb
  RxString storageLocation = ''.obs;
  RxString language = 'en'.obs;
  RxString uploadLimitUnit = 'KB'.obs;
  RxString downloadLimitUnit = 'KB'.obs;

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
  void setUser(UserMeta value) => user.value = value;
  void setUserName(String name) => user.value = user.value.copyWith(name: name);
  void setUserColor(Color color) => user.value = user.value.copyWith(color: color);
  //settings
  void setAutoSync(bool value) => isAutoSync.value = value;
  void setOfflineMode(bool value) => isOfflineMode.value = value;
  void setDownloadLimit(int value) => downloadLimit.value = value;
  void setUploadLimit(int value) => uploadLimit.value = value;
  void setUploadLimitUnit(String value) => uploadLimitUnit.value = value;
  void setDownloadLimitUnit(String value) => downloadLimitUnit.value = value;
  void setStorageLocation(String value) => storageLocation.value = value;
  void setLanguage(String value) => language.value = value;

}

import 'dart:ui';

import 'package:formbuilder/backend/models/collection/collection.dart';
import 'package:get/get.dart';

import '../backend/models/account/user.dart';
import '../backend/models/form/screen.dart';
import '../backend/models/path.dart';
import 'tools.dart';

class Provider extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isSideBarOpen = true.obs;
  Rx<User> user = User(name: "Guest", color: getRandomHighContrastColor()).obs;
  final RxList<Path> currentPath = <Path>[AppPath.home.data()].obs;

  //settings
  RxBool isDark = false.obs;
  RxBool isGrid = true.obs;
  RxString language = 'en'.obs;
  final RxnString currentFolderId = RxnString();
  //account settings
  RxBool pushNotifications = true.obs;
  RxBool emailNotifications = true.obs;

  //quick
  RxString newSelectedStoragePath = ''.obs;
  RxBool shouldCenterCanvas = false.obs;
  final RxInt zoomTrigger = 0.obs; // 1 = zoom in, -1 = zoom out, 0 = no action (for canva)
  RxList<Connect> connects = <Connect>[].obs;

  void zoomIn() {
    zoomTrigger.value = 1;
  }

  void zoomOut() {
    zoomTrigger.value = -1;
  }

  void centerCanvas() {
    shouldCenterCanvas.value = true;
  }
  void resetCurrentFolderId(List<Collection> allCollections){
    currentFolderId.value = allCollections
        .firstWhere((c) => c.parentId == null)
        .id;
  }

  void setIsGrid(bool value) {
    isGrid.value = value;
  }
  Future<void> setIsGridFuture(Future<bool> value) async {
    isGrid.value = await value;
  }
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

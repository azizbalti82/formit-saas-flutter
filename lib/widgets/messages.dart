import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../services/themeService.dart';

void showError(String message, BuildContext context,{int? autoCloseDuration}) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: Duration(seconds: autoCloseDuration??3),
    title: Text(
      message,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      maxLines: 10,
      overflow: TextOverflow.visible,
      softWrap: true,
    ),

  alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 500),
    icon: const Icon(Icons.warning_amber),
    showIcon: false,
    // show or hide the icon
    primaryColor: Colors.red,
    backgroundColor: Colors.red.withOpacity(0.05),
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

void showSuccess(String message, BuildContext context) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(
      message,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      maxLines: 10,
      overflow: TextOverflow.visible,
      softWrap: true,
    ),
    alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 500),
    icon: const Icon(Icons.check),
    showIcon: false,
    // show or hide the icon
    primaryColor: Colors.green,
    backgroundColor: Colors.green.withOpacity(0.1),
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

void showMsg(String message, BuildContext context,theme t) {
  toastification.show(
    context: context,
    type: ToastificationType.info,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(
      message,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      maxLines: 10,
      overflow: TextOverflow.visible,
      softWrap: true,
    ),    alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 500),
    icon: null,
    showIcon: false,
    // show or hide the icon
    primaryColor: t.accentColor,
    backgroundColor: t.accentColor.withOpacity(0.05),
    foregroundColor: t.accentColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

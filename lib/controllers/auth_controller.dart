import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_frontend/screens/home_screen.dart';
import 'dart:html' as html;

class AuthController extends GetxController {
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    html.window.onBeforeUnload.listen((event) {
      logout();
    });
  }

  void login(String? password) {
    //check for null and then snackbar
    if (password == null) {
      Get.snackbar(
        'Error',
        'Invalid password',
        backgroundColor: Colors.grey.withOpacity(0.2),
        colorText: Colors.red,
      );
      return;
    }

    //get the current time format HH::MM
    DateTime now = DateTime.now();
    String currentTime = '';
    if (now.minute < 10) {
      currentTime = '${now.hour}0${now.minute}';
    } else {
      currentTime = '${now.hour}${now.minute}';
    }

    if (password == currentTime) {
      print(isAuthenticated.value);
      isAuthenticated.value = true;
      //go to new page
      Get.offAllNamed(Homescreen.routeName);
    } else {
      //show an error message
      Get.snackbar(
        'Error',
        'Invalid password',
        backgroundColor: Colors.grey.withOpacity(0.2),
        colorText: Colors.red,
      );
    }
  }

  void logout() {
    isAuthenticated.value = false;
  }
}

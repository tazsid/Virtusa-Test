import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static void print(message) {
    if (!kReleaseMode) {
      debugPrint(message.toString());
    }
  }

  static Future<bool> isNetworkConnected() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } on SocketException catch (_) {
      Utils.showSnackbar('No Internet Connection');
      return false;
    }
  }

  static void showSnackbar(String text) {
    Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        borderRadius: 0,
        margin: EdgeInsets.zero,
        messageText: Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade900);
  }

  static void showLoader() {
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 40, width: 40, child: CircularProgressIndicator()),
          ],
        ));

    Get.generalDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Container(
                alignment: Alignment.center,
                child: alert,
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
    );
  }

  static void hideLoader() {
    Get.back();
  }
}

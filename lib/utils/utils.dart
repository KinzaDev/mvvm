import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static double averageRating(List<dynamic>? ratings) {
    if (ratings == null || ratings.isEmpty) {
      return 0.0;
    }
    var avgRating = 0.0;
    int count = 0;
    for (int i = 0; i < ratings.length; i++) {
      final val = ratings[i];
      if (val is num) {
        avgRating += val;
        count++;
      } else if (val != null) {
        final parsed = double.tryParse(val.toString());
        if (parsed != null) {
          avgRating += parsed;
          count++;
        }
      }
    }
    if (count == 0) return 0.0;
    return avgRating / count;
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      message: message,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      reverseAnimationCurve: Curves.easeInOut,
      positionOffset: 20,
      icon: const Icon(
        Icons.error,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      message: message,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.green,
      reverseAnimationCurve: Curves.easeInOut,
      positionOffset: 20,
      icon: const Icon(
        Icons.check_circle,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);
  }

  static void snackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }
}

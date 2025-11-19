import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateLeagueValidation {
  static bool validateLeagueForm({
    required String leagueName,
    required String description,
    required String startDate,
    required String location,
    required String totalGameWeeks,
  }) {
    if (leagueName
        .trim()
        .isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a league name',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (description
        .trim()
        .isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a description',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (startDate
        .trim()
        .isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a start date',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (location
        .trim()
        .isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a location',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Validate total game weeks
    try {
      int.parse(totalGameWeeks.trim());
    } catch (e) {
      Get.snackbar('Validation Error',
          'Please enter a valid number for total game weeks',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  static String? validateAndFormatDate(String dateString) {
    try {
      final dateParts = dateString.trim().split('-');
      if (dateParts.length == 3) {
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);
        return DateTime(year, month, day).toIso8601String();
      } else {
        throw FormatException('Invalid date format');
      }
    } catch (e) {
      Get.snackbar('Validation Error', 'Please enter date in YYYY-MM-DD format',
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  static DateTime calculateEndDate(String formattedStartDate,
      int totalGameWeeks) {
    final DateTime startDateParsed = DateTime.parse(formattedStartDate);
    return startDateParsed.add(Duration(days: totalGameWeeks * 7));
  }
}
import 'dart:io';

import 'package:get/get.dart';
import 'package:karlfive/core/network/services/multiple_form_data_manager.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';

class EditProfileController extends GetxController {
  final UserInfoRepo _repo;
  EditProfileController(this._repo);

  final RxBool isLoading = false.obs;

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String birthday,
    required String gender,
    File? image,
  }) async {
    try {
      isLoading.value = true;

      final manager = MultiFormDataManager();
      final fullName = '${firstName.trim()} ${lastName.trim()}'.trim();
      manager.addTextData('name', fullName);
      manager.addTextData('email', email);
      manager.addTextData('phoneNumber', phone);
      // Validate & convert birthday (UI shows dd/MM/yyyy) to ISO yyyy-MM-dd
      if (birthday.trim().isNotEmpty) {
        final isoBirthday = _convertBirthdayToIso(birthday.trim());
        if (isoBirthday == null) {
          Get.snackbar('Invalid birthday', 'Please enter birthday in DD/MM/YYYY format');
          return false;
        }
        manager.addTextData('birthday', isoBirthday);
      }
      manager.addTextData('gender', gender);

      if (image != null) {
        manager.addImageFile(image);
      }

      final formData = await manager.toFormDataWithValidation();

      final result = await _repo.updateprofile(formData);

      bool success = false;
      result.fold((failure) {
        Get.snackbar('Error', failure.message);
        success = false;
      }, (suc) {
        Get.snackbar('Success', suc.message);
        success = true;
      });

      return success;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Convert birthday from DD/MM/YYYY (or D/M/YYYY) to ISO YYYY-MM-DD
  // Returns null when the input is invalid.
  String? _convertBirthdayToIso(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) return null;

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) return null;

      // Basic range checks
      if (year < 1900 || year > 2100) return null;
      if (month < 1 || month > 12) return null;

      final daysInMonth = <int>[0, 31, _isLeapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      if (day < 1 || day > daysInMonth[month]) return null;

  final mm = month.toString().padLeft(2, '0');
  final dd = day.toString().padLeft(2, '0');
  return '${year.toString().padLeft(4, '0')}-$mm-$dd';
    } catch (_) {
      return null;
    }
  }

  bool _isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    return year % 400 == 0;
  }
}

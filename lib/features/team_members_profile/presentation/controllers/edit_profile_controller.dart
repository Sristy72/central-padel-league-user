import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../EntireScreen/domain/repo/user_info_repo.dart';

class EditProfileController extends GetxController {
  final UserInfoRepo _repo;
  final AuthStorageService _authStorageService;

  EditProfileController(this._repo, this._authStorageService);

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

      // Always send birthday - convert to ISO format if provided
      if (birthday.trim().isNotEmpty) {
        final isoBirthday = _convertBirthdayToIso(birthday.trim());
        if (isoBirthday == null) {
          Get.snackbar(
            'Invalid Birthday',
            'Please select a valid date using the calendar',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        manager.addTextData('birthday', isoBirthday);
      } else {
        // Send empty string if no birthday to ensure field is updated
        manager.addTextData('birthday', '');
      }

      manager.addTextData('gender', gender);

      // Do not add the image to the manager (it would use the 'images' field name).
      // Instead, validate text fields first then attach the single profile image under 'image'.
      final formData = await manager.toFormDataWithValidation();

      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await dio.MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      final result = await _repo.updateprofile(formData);

      bool success = false;
      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
          success = false;
        },
        (suc) {
          Get.snackbar('Success', suc.message);
          success = true;
        },
      );

      return success;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Convert birthday from DD/MM/YYYY (or D/M/YYYY) to ISO YYYY-MM-DD
  // Also handles if birthday is already in ISO format (with or without time)
  // Returns null when the input is invalid.
  String? _convertBirthdayToIso(String input) {
    try {
      // If it contains 'T', it's full ISO datetime - extract date part
      String dateStr = input;
      if (input.contains('T')) {
        dateStr = input.split('T').first;
      }

      // If in ISO format (YYYY-MM-DD), validate and return
      if (dateStr.contains('-') && dateStr.split('-').length == 3) {
        final parts = dateStr.split('-');
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year != null && month != null && day != null && year > 1900) {
          // Already ISO format, return date part only
          return dateStr;
        }
      }

      // Handle DD/MM/YYYY format
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length != 3) return null;

        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day == null || month == null || year == null) return null;

        // Basic range checks
        if (year < 1900 || year > 2100) return null;
        if (month < 1 || month > 12) return null;

        final daysInMonth = <int>[
          0,
          31,
          _isLeapYear(year) ? 29 : 28,
          31,
          30,
          31,
          30,
          31,
          31,
          30,
          31,
          30,
          31,
        ];
        if (day < 1 || day > daysInMonth[month]) return null;

        final mm = month.toString().padLeft(2, '0');
        final dd = day.toString().padLeft(2, '0');
        return '${year.toString().padLeft(4, '0')}-$mm-$dd';
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  bool _isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    return year % 400 == 0;
  }

  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;

      // Get the current user ID
      final userId = await _authStorageService.getUserId();

      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          'Error',
          'User ID not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final result = await _repo.deleteAccount(userId);

      bool success = false;
      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
          success = false;
        },
        (response) {
          Get.snackbar(
            'Success',
            'Account deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          success = true;
        },
      );

      return success;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

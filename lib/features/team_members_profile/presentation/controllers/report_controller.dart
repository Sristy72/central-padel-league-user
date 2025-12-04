import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../domain/repo/report_repo.dart';

class ReportController extends GetxController {
  final ReportRepo _reportRepo;
  ReportController(this._reportRepo);

  final isLoading = false.obs;

  Future<void> createReport({
    required String userId,
    required String even,
    required String description,
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;

      // Build FormData manually to ensure the file field name matches the backend
      final formData = FormData();
      formData.fields.add(MapEntry('user', userId));
      formData.fields.add(MapEntry('even', even));
      formData.fields.add(MapEntry('description', description));

      if (imageFile != null) {
        final fileName = imageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'file', // backend expects 'file' key in form-data (see Postman example)
          await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          ),
        ));
      }

      final result = await _reportRepo.report(formData);

      result.fold(
            (failure) {
          Get.snackbar("Failed", failure.message);
        },
            (success) {
          Get.snackbar("Success", "Report submitted successfully");
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:io';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../domain/repo/contact_us_repo.dart';


class ReportController extends GetxController {
  final ContactUsRepo _contactUsRepo;

  ReportController(this._contactUsRepo);

  final MultiFormDataManager multiFormDataManager = MultiFormDataManager();

  final isLoading = false.obs;

  Future<void> createReport({
    required String userId,
    required String even,
    required String description,
    File? imageFile,
  }) async {

    multiFormDataManager.addTextData("even", even);
    multiFormDataManager.addTextData("description", description);
    // multiFormDataManager.addImageFile(imageFile.path);

    final formData = multiFormDataManager.toFormData();

    final result = await _contactUsRepo.report(formData);

    result.fold((fail) {}, (success) {});

  }
}

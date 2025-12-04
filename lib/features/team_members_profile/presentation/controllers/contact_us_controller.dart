import 'dart:developer' as DPrint;
import '../../../../core/base/base_controller.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../domain/repo/contact_us_repo.dart';

class ContactUsController extends BaseController {
  final ContactUsRepo _contactUsRepo;

  ContactUsController(this._contactUsRepo);

  Future<bool> createContact({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String subject,
    required String yourCompany,
  }) async {
    try {
      isLoading.value = true;

      final request = ContactUsRequestModel(
        firstName: firstName,
        lastName: lastName,
        address: address,
        phoneNumber: phoneNumber,
        subject: subject,
        yourCompany: yourCompany,
      );

      DPrint.log("Contact Us request: ${request.toJson()}");

      final result = await _contactUsRepo.createContact(request);

      bool success = false;

      result.fold(
            (fail) {
          DPrint.log("Contact us failed: ${fail.message}");
          setError(fail.message);
        },
            (res) {
          DPrint.log("Contact us success: ${res.message}");
          success = true;
        },
      );

      return success;
    } catch (e) {
      DPrint.log("⚠️ ContactUsController Exception: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

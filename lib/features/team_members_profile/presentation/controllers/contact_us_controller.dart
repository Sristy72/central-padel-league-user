import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/debug_print.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../domain/repo/contact_us_repo.dart';


class ContactUsController extends BaseController {
  final ContactUsRepo _contactUsRepo;

  ContactUsController(this._contactUsRepo);

  Future<void> createContact({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String subject,
    required String yourCompany,
  }) async {
    setLoading(true);
    clearError();

    final request = ContactUsRequestModel(
      firstName: firstName,
      lastName: lastName,
      address: address,
      phoneNumber: phoneNumber,
      subject: subject,
      yourCompony: yourCompany,
    );
    DPrint.log("Contact Us create data : ${request.toJson()}");

    final result = await _contactUsRepo.createContact(request);
    
    result.fold((fail) {
      DPrint.log("concat us create fail : ${fail.message}");
      setError(fail.message);
      setLoading(false);
    }, (success) {
      DPrint.log("concat us create success : ${success.message}");
      setLoading(false);
      // Trigger success callback if provided
      if (onSuccess != null) {
        onSuccess!(success.message);
      }
    });
  }

  // Callback for success handling
  Function(String)? onSuccess;
}

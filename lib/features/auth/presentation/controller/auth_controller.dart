import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/data/models/register_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_request_model.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/auth/presentation/screens/after_login.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_screen.dart';

import '../../../../core/network/services/auth_storage_service.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;

  AuthController(this._authRepository, this._authStorageService);

  // Login
  Future<void> login(String email, String password) async {
    setLoading(true);

    final request = LoginRequestModel(email: email, password: password);

    final result = await _authRepository.login(request);

    result.fold(
      (fail) {
        setLoading(false);
      },
      (success) async {
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: success.data.user.id,
        );
        setLoading(false);

        Get.to(() => AfterLoginScreen());
      },
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    setLoading(true);

    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (fail) {
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
      (succees) {
        DPrint.log("Register success result : ${succees.data.id}");
        setLoading(false);

      },
    );
  }

  Future resetPass(String email) async{
    setLoading(true);

    final request = ResetPasswordRequestModel(email: email);
    final result = await _authRepository.resetPassword(request);

    result.fold((fail){DPrint.log("reset pass success result : ${fail.message}");
    setLoading(false);}, (success){DPrint.log("reset pass success result : ${success.data.message}");
    setLoading(false);});
    Get.to(OtpVerificationScreen(email: email,));
  }
}

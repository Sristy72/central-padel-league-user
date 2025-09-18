import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/auth/presentation/screens/after_login.dart';
import 'package:karlfive/features/join_league/presentation/screens/form_screen/join_league_screen.dart';

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

        Get.to(() => JoinLeagueScreen(),transition: Transition.rightToLeft);
      },
    );
  }
}

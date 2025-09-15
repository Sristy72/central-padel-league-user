import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/utils/debug_print.dart';

class AuthController extends BaseController {
  // Login
  Future<void> login(String email, String password) async {
    setLoading(true);

    await Future.delayed(const Duration(seconds: 5));

    DPrint.log("Login Success - Email: $email and Password: $password");

    setError("Error message show");

    setLoading(false);
  }
}

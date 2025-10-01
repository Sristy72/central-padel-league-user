import 'package:get/get.dart';
import 'package:karlfive/features/team_members_profile/data/models/user_profile_model.dart';
import 'package:karlfive/features/team_members_profile/domain/repo/user_profile_repo.dart';

class ProfileController extends GetxController {
  final UserProfileRepo repository;

  ProfileController({required this.repository});

  final Rxn<UserProfileModel> profile = Rxn<UserProfileModel>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final result = await repository.getProfile();
      result.fold((failure) {
        error.value = failure.message;
      }, (success) {
        profile.value = success.data;
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

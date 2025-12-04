import 'dart:developer' as DPrint;
import 'package:get/get.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/repo/user_profile_repo.dart';

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
      DPrint.log('ProfileController: fetching profile...');
      final result = await repository.getProfile();
      result.fold((failure) {
        DPrint.log('ProfileController: fetch failed: ${failure.message}');
        error.value = failure.message;
      }, (success) {
        DPrint.log('ProfileController: fetch success: ${success.message}');
        profile.value = success.data;
      });
    } catch (e) {
      DPrint.log('ProfileController: exception during fetch: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
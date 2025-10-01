import 'dart:io';

import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/network/services/multiple_form_data_manager.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';

import '../../../core/utils/debug_print.dart';

class UserInfoController extends BaseController {
  final UserInfoRepo _userInfoRepo;

  UserInfoController(this._userInfoRepo);

  final _multiFormDataManager = MultiFormDataManager();

  var selectedLevel = ''.obs;
  var selectedgenders = ''.obs;
  var photo = Rx<File?>(null);
  var mobileNumber = ''.obs;

  void printUserInfo() {
    print("Playing Level: ${selectedLevel.value}");
    print("Gender: ${selectedgenders.value}");
    print("Phone Number: ${mobileNumber.value}");
    print("Image Path: ${photo.value?.path ?? 'No image selected'}");
  }

  Future<void> saveUserInfo({
    String? level,
    String? selectedGender,
    File? image,
    String? mobile,
  }) async {
    if (level != null) selectedLevel.value = level;
    if (selectedGender != null) selectedgenders.value = selectedGender;
    if (image != null) photo.value = image;
    if (mobile != null) mobileNumber.value = mobile;

    _multiFormDataManager.addTextData("playingLevel", selectedLevel.string);
    _multiFormDataManager.addTextData("gender", selectedGender.toString());
    _multiFormDataManager.addTextData("phoneNumber", mobileNumber.string);
    _multiFormDataManager.addTextData("name", "Marjana");
    _multiFormDataManager.addTextData("clubAffiliation", "Barcelona");

    // _multiFormDataManager.addImageFile(image!);

    // _multiFormDataManager.addImageFile(image!);

    final formData = await _multiFormDataManager.toFormDataWithValidation(
      // allowedImageTypes: const ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    );

    final result = await _userInfoRepo.updateprofile(formData);

    result.fold(
      (fail) {
        DPrint.log("Profile success result : ${fail.message}");
        setLoading(false);
      },
      (succees) {
        DPrint.log("Profile success result : ${succees.message}");
        setLoading(false);
      },
    );
  }
}

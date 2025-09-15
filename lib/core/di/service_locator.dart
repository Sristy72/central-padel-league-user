import 'package:get/get.dart';

import 'set_controllers.dart';
import 'setup_usecases.dart';
import 'setup_core.dart';
import 'setup_repository.dart';
import 'setup_services.dart';

// final sl = Get.find();

void setupServiceLocator() {
  // Core Services
  setupCore();

  // Repositories
  setupRepository();

  // Use Cases
  setupUsecases();

  // Controllers
  setupController();

  // Services
  setupServices();
}

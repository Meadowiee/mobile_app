import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';

class ProfileController extends GetxController {
  final ProfileApiService apiService = ProfileApiService();
  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProfileById("c59baf08-780b-4898-afe1-e98886bb2059"); // data dummy
    super.onInit();
  }

  void fetchProfileById(String id) async {
    try {
      isLoading.value = true;
      final data = await apiService.fetchProfileById(id);
      profile.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void editProfile(String id, Profile profile) async {
    try {
      await apiService.updateProfile(id, profile);
      fetchProfileById(id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

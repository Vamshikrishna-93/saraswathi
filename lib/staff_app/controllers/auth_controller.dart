import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/utils/get_storage.dart';
import '../api/api_service.dart';
import 'profile_controller.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  // ================= LOGIN =================
  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;

      // ✅ CALL DEDICATED LOGIN API (MATCHES POSTMAN)
      final response = await ApiService.login(
        username: username,
        password: password,
      );

      // ✅ SUCCESS CHECK - Handle different success formats
      final isSuccess =
          response["success"] == true ||
          response["success"] == "true" ||
          response["success"] == 1;

      if (isSuccess && response["access_token"] != null) {
        // 🔥 CLEAR PREVIOUS USER'S PROFILE DATA (MULTI-USER SUPPORT)
        _clearProfileController();

        // 🔐 SAVE SESSION
        AppStorage.saveToken(response["access_token"]);
        AppStorage.saveUserId(response["userid"]);
        AppStorage.setLoggedIn(true);

        // 🔥 SAVE MULTI-USER SESSION
        AppStorage.saveUserSession({
          'user_login': username,
          'userid': response['userid'],
          'login_type': response['login_type'],
          'role': response['role'],
          'permissions': response['permissions'],
          // We don't have name/avatar yet, ProfileController will fetch them later
        }, response["access_token"]);

        // 🔥 FETCH PROFILE IMMEDIATELY AFTER LOGIN
        // This ensures Dashboard/Drawer have user data right away
        final profileController = Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());

        // Use await to ensure profile is fetched before moving to dashboard
        // If it fails, we still go to dashboard but user info might be missing
        profileController.fetchProfile().catchError((e) {
          debugPrint("PROFILE FETCH FAILED AFTER LOGIN: $e");
        });

        // 🚀 GO TO DASHBOARD
        Get.offAllNamed('/dashboard');
      } else {
        // Extract error message
        final errorMsg =
            response["message"] ??
            response["error"] ??
            response["msg"] ??
            "Invalid credentials";

        Get.snackbar(
          "Login Failed",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR => $e");

      // Extract error message from exception
      String errorMessage = "Server connection failed";
      final errorString = e.toString();

      if (errorString.contains("Invalid") ||
          errorString.contains("credentials") ||
          errorString.contains("Invalid credentials")) {
        errorMessage = "Invalid credentials";
      } else if (errorString.contains("Network") ||
          errorString.contains("connection")) {
        errorMessage = "Network error: Please check your internet connection";
      } else if (errorString.contains("timeout") ||
          errorString.contains("Timeout")) {
        errorMessage = "Connection timeout: Please try again";
      } else if (errorString.contains("Server error")) {
        errorMessage = "Server error: Please try again later";
      } else {
        // Try to extract the actual error message from the exception
        // Remove "Exception: " prefix if present
        errorMessage = errorString.replaceFirst("Exception: ", "").trim();
        if (errorMessage.isEmpty) {
          errorMessage = "Login failed: Please try again";
        }
      }

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CLEAR PROFILE CONTROLLER =================
  void _clearProfileController() {
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      // Clear profile data
      profileController.profile.value = null;
      profileController.isLoading.value = true;
    }
  }

  // ================= LOGOUT =================
  void logout() {
    // 🚀 1. Clear Session
    AppStorage.clear();

    // 🧹 2. Clear related controllers
    if (Get.isRegistered<ProfileController>()) {
      Get.delete<ProfileController>(force: true);
    }

    // 🚪 3. GO BACK TO LOGIN (via auth wrapper — session is cleared so it shows LoginPage)
    Get.offAllNamed('/authWrapper');
  }
}

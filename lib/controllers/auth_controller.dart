import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:chat_app/main.dart';
import '../../services/auth_service.dart';
import '../screens/chats/chat_list_screen.dart';

// We extend GetxController to manage state and logic outside the UI layers.
class AuthController extends GetxController {
  // Rxn<User> is a Nullable Reactive variable. It observes Firebase User changes.
  final Rxn<User> firebaseUser = Rxn<User>();

  // .obs makes these standard variables Reactive.
  // Whenever their values change, any Obx widget listening to them will rebuild automatically.
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    // bindStream automatically links our reactive variable to Firebase authStateChanges stream.
    // This allows the app to know instantly if a user logs in or out.
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  // Handle Login Logic
  Future<void> loginUser(String email, String password) async {
    try {
      // Accessing and updating the value of an Rx variable using `.value`
      isLoading.value = true;

      await AuthService().login(email: email, password: password);

      Get.offAll(() => ChatsListScreen());
    } catch (e) {
      String errorMsg = 'An error occurred';
      if (e is FirebaseAuthException) errorMsg = e.code;

      // Get.snackbar is a built-in GetX method to show snackbars without using BuildContext
      Get.snackbar(
        'Login Failed',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Registration Logic
  Future<void> registerUser(String name, String email, String password) async {
    try {
      isLoading.value = true;
      await AuthService()
          .register(name: name, email: email, password: password);

      Get.offAll(() => ChatsListScreen());

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        Get.snackbar(
          'Registration Failed',
          e.code,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Logout Logic
  Future<void> logoutUser() async {
    await AuthService().logout();
    Get.offAll(() => const AuthWrapper());
  }
}
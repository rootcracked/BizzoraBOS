import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizzora_mobile/core/storage_service.dart';
import 'package:bizzora_mobile/features/auth/Auth_Service/auth_service.dart';
import 'package:bizzora_mobile/features/auth/models/login_request.dart';
import 'package:bizzora_mobile/features/auth/models/register_request.dart';
import 'package:bizzora_mobile/features/auth/models/user_model.dart';
import 'authState.dart';

class AuthNotifier extends Notifier<AuthState> {
  final _authService = AuthService();

  @override
  AuthState build() {
    // Runs when provider is first created
    // Optionally auto-check token here
    return AuthState.initial();
  }

  // ---------------- REGISTER ----------------
  Future<UserResponse> register(
    String businessName,
    String username,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final request = RegisterRequest(
        business_name: businessName,
        username: username,
        email: email,
        password: password,
      );

      final user = await _authService.register(request);

      // Save token securely
      await StorageService.saveToken(user.token);

      // Update state
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        token: user.token,
        user: user,
      );
      print("admin you logged in successfully");
      return user; // ✅ return so UI can use it
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // ✅ allow UI to show error message
    }
  }

  // ---------------- LOGIN ----------------
  Future<UserResponse> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final request = LoginRequest(email: email, password: password);
      final user = await _authService.login(request);

      await StorageService.saveToken(user.token);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        token: user.token,
        user: user,
      );

      return user; // ✅ return user for UI feedback
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      print(e);
      rethrow;
    }
  }

  // ---------------- CHECK AUTH ----------------
  Future<void> checkAuth() async {
    final token = await StorageService.getToken();
    if (token != null) {
      state = state.copyWith(isAuthenticated: true, token: token);
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logOut() async {
    await StorageService.clearToken();
    state = AuthState.initial();
  }
}

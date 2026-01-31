import 'package:bizzora_mobile/features/auth/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? token;
  final String? role;
  final UserResponse? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.token,
    this.role,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? token,
    String? role,
    UserResponse? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      role: role ?? this.role,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() => AuthState(isAuthenticated: false);
}

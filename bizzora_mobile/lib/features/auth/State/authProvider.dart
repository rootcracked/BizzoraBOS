import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'authNotifier.dart';
import 'package:bizzora_mobile/features/auth/State/authState.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

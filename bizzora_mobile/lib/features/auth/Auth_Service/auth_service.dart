import 'dart:convert';

import 'package:bizzora_mobile/core/api_service.dart';
import 'package:bizzora_mobile/core/storage_service.dart';
import 'package:bizzora_mobile/features/auth/models/register_request.dart';
import 'package:bizzora_mobile/features/auth/models/login_request.dart';
import 'package:bizzora_mobile/features/auth/models/user_model.dart';


class AuthService {
  final ApiClient _apiClient = ApiClient();
  
  Future<UserResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post('/register', request.toJson());
    final data = jsonDecode(response.body);

    
    

    if (response.statusCode == 200 || response.statusCode == 201){
      final user = UserResponse.fromJson(data);
      if (user.token != null) {
        await StorageService.saveToken(user.token!);
        
      }
      return user;
    } else {
      
      throw Exception(data['message'] ?? 'Registration Failed');
      
    }
  }

  Future<UserResponse> login(LoginRequest request) async {
    final response = await _apiClient.post('/login', request.toJson());
    final data = jsonDecode(response.body);

    if (response.statusCode == 200){
      return UserResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Login Failed');
    }
  } 

  
}

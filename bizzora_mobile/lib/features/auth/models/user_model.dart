class UserResponse {
  final String id;
  final String username;
  final String email;
  final String businessName;
  final String businessId;
  final String role;
  final String token;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.businessName,
    required this.businessId,
    required this.role,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final userInfo = json['user'];
    return UserResponse(
      id: userInfo['id']?.toString() ?? '',
      username: userInfo['username'] ?? '',
      email: userInfo['email'] ?? '',
      businessName: userInfo['business_name'] ?? '',
      businessId: userInfo['business_id']?.toString() ?? '',
      role: userInfo['role'] ?? '',
      token: json['token'] ?? '',
    );
  }
}


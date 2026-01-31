class RegisterRequest {
  final String business_name;
  final String username;
  final String email;
  final String password;

  RegisterRequest({
    required this.business_name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'business_name': business_name,
        'username': username,
        'email': email,
        'password': password,
      };
}


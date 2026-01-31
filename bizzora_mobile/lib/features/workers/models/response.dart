class Response {
  final String id;
  final String businessID;
  final String businessName;
  final String username;
  final String phoneNumber;
  final String email;
  final String password;
  final String token;
  final String role;

  Response({
    required this.id,
    required this.businessID,
    required this.businessName,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.role,
    required this.token,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    final workerInfo = json["user"];
    return Response(
      id: workerInfo["ID"]?.toString() ?? '',
      businessID: workerInfo["business_id"]?.toString() ?? '',
      businessName: workerInfo["business_name"] ?? '',
      username: workerInfo['username'] ?? '',
      phoneNumber: workerInfo['phone_number'] ?? '',
      email: workerInfo['email']?.toString() ?? '',
      password: workerInfo["password"] ?? '',
      role: workerInfo["role"] ?? '',
      token: workerInfo["token"] ?? '',
    );
  }
}

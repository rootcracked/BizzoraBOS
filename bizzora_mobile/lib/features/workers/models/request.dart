class Request {
  final String workerName;
  final String phoneNumber;
  final String email;
  final String password;

  Request({
    required this.workerName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': workerName,
    'phone_number': phoneNumber,
    'email': email,
    'password': password,
  };
}

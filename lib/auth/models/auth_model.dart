
class LoginData {
  final String id;
  final String token;

  LoginData({required this.id, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      id: json['id'].toString(), 
      token: json['token'] ?? "", 
    );
  }
}

class LoginResponse {
  final String? message;
  final LoginData? user; 

  LoginResponse({this.message, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      user: json['user'] != null ? LoginData.fromJson(json['user']) : null,
    );
  }
}
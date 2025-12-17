class Register {
  final String id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? region;
  final String? sex;
  final String? profileImage;

  Register({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.region,
    this.sex,
    this.profileImage,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['id'],
      name: json['name'] ?? "",
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      region: json['region'],
      sex: json['sex'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id' : id, 'name': name, 'username': username, 'email': email, 'password': password, 'region': region, 'sex': sex, 'profileImage': profileImage};
  }
}

class Profile {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? sex;
  final String? region;
  final String? created_at;
  final String? updated_at;

  final String password;
  final String username;

  Profile({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.sex,
    this.region,
    this.created_at,
    this.updated_at,

    required this.password,
    required this.username,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      sex: json['sex'] as String?,
      region: json['region'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,

      username: json['username'] ?? "",
      password: json['password'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'sex': sex,
      'region': region,
      'username': username,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? sex,
    String? region,
    String? profileImage,
    String? password,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      sex: sex ?? this.sex,
      region: region ?? this.region,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

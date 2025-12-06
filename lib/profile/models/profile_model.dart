class Profile {
  final String? id;
  final String? name;
  final String? email;
  final String? profile_image;
  final String? created_at;
  final String? updated_at;

  final String password;
  final String username;

  Profile({
    this.id,
    this.name,
    this.email,
    this.profile_image,
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
      profile_image: json['profile_image'] as String?,
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
      'profile_image': profile_image,
      'username': username,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

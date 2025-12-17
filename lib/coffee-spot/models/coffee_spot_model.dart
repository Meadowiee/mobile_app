class CoffeeSpot {
  final String id;
  final String name;
  final String? address;
  final String? urlAddress;
  final String? urlBlog;
  final String? image;
  final String? contact;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoffeeSpot({
    required this.id,
    required this.name,
    this.address,
    this.urlAddress,
    this.urlBlog,
    this.image,
    this.contact,
    required this.createdAt,
    required this.updatedAt,
  });

  String get titleCaseName {
    if (name.isEmpty) {
      return name;
    }
    return name
        .toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  factory CoffeeSpot.fromJson(Map<String, dynamic> json) {
    return CoffeeSpot(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      urlAddress: json['urlAddress'] as String?,
      urlBlog: json['urlBlog'] as String?,
      image: json['image'] as String?,
      contact: json['contact'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'urlAddress': urlAddress,
      'urlBlog': urlBlog,
      'image': image,
      'contact': contact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

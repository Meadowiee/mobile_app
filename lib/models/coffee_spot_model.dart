class CoffeeSpot {
  final String id;
  final String name;
  final String address;
  final String url_address;
  final String url_blog;
  final String image;
  final String contact;
  final String created_at;
  final String updated_at;

  CoffeeSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.url_address,
    required this.url_blog,
    required this.image,
    required this.contact,
    required this.created_at,
    required this.updated_at,
  });

  factory CoffeeSpot.fromJson(Map<String, dynamic> json) {
    return CoffeeSpot(
      id: json['id'],
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      url_address: json['url_address'] ?? "",
      url_blog: json['url_blog'] ?? "",
      image: json['image'] ?? "",
      contact: json['contact'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'url_address': url_address,
      'url_blog': url_blog,
      'image': image,
      'contact': contact,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

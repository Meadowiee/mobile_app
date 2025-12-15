import 'coffee_spot_model.dart';

class SpotCheck {
  final String id;
  final String spotId;
  final String userId;
  final DateTime lastVisit;
  final int visitCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CoffeeSpot? spot;

  SpotCheck({
    required this.id,
    required this.spotId,
    required this.userId,
    required this.lastVisit,
    required this.visitCount,
    required this.createdAt,
    required this.updatedAt,
    this.spot,
  });

  factory SpotCheck.fromJson(Map<String, dynamic> json) {
    return SpotCheck(
      id: json['id'] as String,
      spotId: json['spotId'] as String,
      userId: json['userId'] as String,
      lastVisit: DateTime.parse(json['lastVisit'] as String),
      visitCount: json['visitCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      spot: json['spot'] != null
          ? CoffeeSpot.fromJson(json['spot'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spotId': spotId,
      'userId': userId,
      'lastVisit': lastVisit.toIso8601String(),
      'visitCount': visitCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (spot != null) 'spot': spot!.toJson(),
    };
  }
}

class SpotCheckUpdateInput {
  final DateTime lastVisit;
  final int visitCount;

  SpotCheckUpdateInput({required this.lastVisit, required this.visitCount});

  Map<String, dynamic> toJson() {
    return {'lastVisit': lastVisit.toIso8601String(), 'visitCount': visitCount};
  }
}

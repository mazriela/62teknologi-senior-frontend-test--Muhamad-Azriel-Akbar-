// To parse this JSON data, do
//
//     final businessDetailReviewsModel = businessDetailReviewsModelFromJson(jsonString);

import 'dart:convert';

BusinessDetailReviewsModel businessDetailReviewsModelFromJson(String str) => BusinessDetailReviewsModel.fromJson(json.decode(str));

String businessDetailReviewsModelToJson(BusinessDetailReviewsModel data) => json.encode(data.toJson());

class BusinessDetailReviewsModel {
  List<Review>? reviews;
  int? total;
  List<String>? possibleLanguages;

  BusinessDetailReviewsModel({
    this.reviews,
    this.total,
    this.possibleLanguages,
  });

  factory BusinessDetailReviewsModel.fromJson(Map<String, dynamic> json) => BusinessDetailReviewsModel(
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    total: json["total"],
    possibleLanguages: json["possible_languages"] == null ? [] : List<String>.from(json["possible_languages"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
    "total": total,
    "possible_languages": possibleLanguages == null ? [] : List<dynamic>.from(possibleLanguages!.map((x) => x)),
  };
}

class Review {
  String? id;
  String? url;
  String? text;
  int? rating;
  DateTime? timeCreated;
  User? user;

  Review({
    this.id,
    this.url,
    this.text,
    this.rating,
    this.timeCreated,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    url: json["url"],
    text: json["text"],
    rating: json["rating"],
    timeCreated: json["time_created"] == null ? null : DateTime.parse(json["time_created"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "text": text,
    "rating": rating,
    "time_created": timeCreated?.toIso8601String(),
    "user": user?.toJson(),
  };
}

class User {
  String? id;
  String? profileUrl;
  String? imageUrl;
  String? name;

  User({
    this.id,
    this.profileUrl,
    this.imageUrl,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    profileUrl: json["profile_url"],
    imageUrl: json["image_url"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_url": profileUrl,
    "image_url": imageUrl,
    "name": name,
  };
}

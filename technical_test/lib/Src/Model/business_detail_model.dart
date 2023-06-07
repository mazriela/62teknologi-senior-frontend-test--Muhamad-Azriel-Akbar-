// To parse this JSON data, do
//
//     final businessDetailModel = businessDetailModelFromJson(jsonString);

import 'dart:convert';

BusinessDetailModel businessDetailModelFromJson(String str) => BusinessDetailModel.fromJson(json.decode(str));

String businessDetailModelToJson(BusinessDetailModel data) => json.encode(data.toJson());

class BusinessDetailModel {
  String? id;
  String? alias;
  String? name;
  String? imageUrl;
  bool? isClaimed;
  bool? isClosed;
  String? url;
  String? phone;
  String? displayPhone;
  int? reviewCount;
  List<Category>? categories;
  double? rating;
  Location? location;
  Coordinates? coordinates;
  List<String>? photos;
  String? price;
  List<dynamic>? transactions;
  Messaging? messaging;

  BusinessDetailModel({
    this.id,
    this.alias,
    this.name,
    this.imageUrl,
    this.isClaimed,
    this.isClosed,
    this.url,
    this.phone,
    this.displayPhone,
    this.reviewCount,
    this.categories,
    this.rating,
    this.location,
    this.coordinates,
    this.photos,
    this.price,
    this.transactions,
    this.messaging,
  });

  factory BusinessDetailModel.fromJson(Map<String, dynamic> json) => BusinessDetailModel(
    id: json["id"],
    alias: json["alias"],
    name: json["name"],
    imageUrl: json["image_url"],
    isClaimed: json["is_claimed"],
    isClosed: json["is_closed"],
    url: json["url"],
    phone: json["phone"],
    displayPhone: json["display_phone"],
    reviewCount: json["review_count"],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    rating: json["rating"]?.toDouble(),
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
    photos: json["photos"] == null ? [] : List<String>.from(json["photos"]!.map((x) => x)),
    price: json["price"],
    transactions: json["transactions"] == null ? [] : List<dynamic>.from(json["transactions"]!.map((x) => x)),
    messaging: json["messaging"] == null ? null : Messaging.fromJson(json["messaging"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "alias": alias,
    "name": name,
    "image_url": imageUrl,
    "is_claimed": isClaimed,
    "is_closed": isClosed,
    "url": url,
    "phone": phone,
    "display_phone": displayPhone,
    "review_count": reviewCount,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "rating": rating,
    "location": location?.toJson(),
    "coordinates": coordinates?.toJson(),
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
    "price": price,
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x)),
    "messaging": messaging?.toJson(),
  };
}

class Category {
  String? alias;
  String? title;

  Category({
    this.alias,
    this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    alias: json["alias"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "alias": alias,
    "title": title,
  };
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Location {
  dynamic address1;
  dynamic address2;
  String? address3;
  String? city;
  String? zipCode;
  String? country;
  String? state;
  List<String>? displayAddress;
  String? crossStreets;

  Location({
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.zipCode,
    this.country,
    this.state,
    this.displayAddress,
    this.crossStreets,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address1: json["address1"],
    address2: json["address2"],
    address3: json["address3"],
    city: json["city"],
    zipCode: json["zip_code"],
    country: json["country"],
    state: json["state"],
    displayAddress: json["display_address"] == null ? [] : List<String>.from(json["display_address"]!.map((x) => x)),
    crossStreets: json["cross_streets"],
  );

  Map<String, dynamic> toJson() => {
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "city": city,
    "zip_code": zipCode,
    "country": country,
    "state": state,
    "display_address": displayAddress == null ? [] : List<dynamic>.from(displayAddress!.map((x) => x)),
    "cross_streets": crossStreets,
  };
}

class Messaging {
  String? url;
  String? useCaseText;

  Messaging({
    this.url,
    this.useCaseText,
  });

  factory Messaging.fromJson(Map<String, dynamic> json) => Messaging(
    url: json["url"],
    useCaseText: json["use_case_text"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "use_case_text": useCaseText,
  };
}

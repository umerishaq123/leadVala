import '../config.dart';

// class PrimaryAddress {
//   int? id;
//   String? userId;
//   String? serviceId;
//   int? isPrimary;
//   String? latitude;
//   String? longitude;
//   String? area;
//   String? postalCode;
//   int? countryId;
//   int? stateId;
//   String? city;
//   String? address;
//   String? type;
//   String? alternativeName;
//   int? alternativePhone;
//   String? code;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   Country? country;
//   Country? state;

//   PrimaryAddress(
//       {this.id,
//         this.userId,
//         this.serviceId,
//         this.isPrimary,
//         this.latitude,
//         this.longitude,
//         this.area,
//         this.postalCode,
//         this.countryId,
//         this.stateId,
//         this.city,
//         this.address,
//         this.type,
//         this.alternativeName,
//         this.alternativePhone,
//         this.code,
//         this.createdAt,
//         this.updatedAt,
//         this.deletedAt,
//         this.country,
//         this.state});

//   PrimaryAddress.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id']?.toString();
//     serviceId = json['service_id'];
//     isPrimary = json['is_primary'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     area = json['area'];
//     postalCode = json['postal_code'];
//     countryId = json['country_id'];
//     stateId = json['state_id'];
//     city = json['city'];
//     address = json['address'];
//     type = json['type'];
//     alternativeName = json['alternative_name'];
//     alternativePhone = json['alternative_phone'];
//     code = json['code']?.toString();
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     country =
//     json['country'] != null ? Country.fromJson(json['country']) : null;
//     state = json['state'] != null ? Country.fromJson(json['state']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['service_id'] = serviceId;
//     data['is_primary'] = isPrimary;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['area'] = area;
//     data['postal_code'] = postalCode;
//     data['country_id'] = countryId;
//     data['state_id'] = stateId;
//     data['city'] = city;
//     data['address'] = address;
//     data['type'] = type;
//     data['alternative_name'] = alternativeName;
//     data['alternative_phone'] = alternativePhone;
//     data['code'] = code;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['deleted_at'] = deletedAt;
//     if (country != null) {
//       data['country'] = country!.toJson();
//     }
//     if (state != null) {
//       data['state'] = state!.toJson();
//     }
//     return data;
//   }
// }

class PrimaryAddress {
  int? id;
  String? userId;
  String? serviceId;
  int? isPrimary;
  String? latitude;
  String? longitude;
  String? area;
  String? postalCode;
  int? countryId;
  int? stateId;
  String? city;
  String? address;
  String? type;
  String? alternativeName;
  String? alternativePhone; // Changed to String for safer handling
  String? code;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Country? country;
  Country? state;

  PrimaryAddress({
    this.id,
    this.userId,
    this.serviceId,
    this.isPrimary,
    this.latitude,
    this.longitude,
    this.area,
    this.postalCode,
    this.countryId,
    this.stateId,
    this.city,
    this.address,
    this.type,
    this.alternativeName,
    this.alternativePhone,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.country,
    this.state,
  });

  /// ✅ **Safe Parsing with Default Values**
  factory PrimaryAddress.fromJson(Map<String, dynamic> json) => PrimaryAddress(
        id: json['id'],
        userId: json['user_id']?.toString(), // ✅ Convert to String if needed
        serviceId: json['service_id']?.toString(), // ✅ Convert to String
        isPrimary: json['is_primary'] ?? 0, // ✅ Default to 0
        latitude:
            json['latitude']?.toString() ?? "", // ✅ Convert & Default to ""
        longitude: json['longitude']?.toString() ?? "",
        area: json['area'] ?? "Unknown", // ✅ Default to "Unknown"
        postalCode: json['postal_code']?.toString() ?? "",
        countryId: json['country_id'] ?? 0,
        stateId: json['state_id'] ?? 0,
        city: json['city'] ?? "Unknown",
        address: json['address'] ?? "No Address Available",
        type: json['type'] ?? "N/A",
        alternativeName: json['alternative_name'] ?? "N/A",
        alternativePhone: json['alternative_phone']?.toString() ??
            "N/A", // ✅ Convert & Default
        code: json['code']?.toString() ?? "N/A",
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
        deletedAt: json['deleted_at']?.toString(),
        country:
            json['country'] != null ? Country.fromJson(json['country']) : null,
        state: json['state'] != null ? Country.fromJson(json['state']) : null,
      );

  /// ✅ **Convert to JSON with Null Checks**
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "is_primary": isPrimary,
        "latitude": latitude,
        "longitude": longitude,
        "area": area,
        "postal_code": postalCode,
        "country_id": countryId,
        "state_id": stateId,
        "city": city,
        "address": address,
        "type": type,
        "alternative_name": alternativeName,
        "alternative_phone": alternativePhone,
        "code": code,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        if (country != null) "country": country!.toJson(),
        if (state != null) "state": state!.toJson(),
      };
}

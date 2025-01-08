// To parse this JSON data, do
//
//     final bookingResponseModel = bookingResponseModelFromJson(jsonString);

import 'dart:convert';

BookingResponseModel bookingResponseModelFromJson(String str) => BookingResponseModel.fromJson(json.decode(str));

String bookingResponseModelToJson(BookingResponseModel data) => json.encode(data.toJson());

class BookingResponseModel {
    int? currentPage;
    List<Datum>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    List<Link>? links;
    dynamic nextPageUrl;
    String? path;
    int? perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

    BookingResponseModel({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    factory BookingResponseModel.fromJson(Map<String, dynamic> json) => BookingResponseModel(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    int? id;
    int? parentId;
    int? bookingNumber;
    int? consumerId;
    dynamic couponId;
    dynamic walletBalance;
    dynamic convertWalletBalance;
    int? providerId;
    int? serviceId;
    dynamic servicePackageId;
    int? addressId;
    int? servicePrice;
    double? tax;
    int? perServicemanCharge;
    int? couponTotalDiscount;
    int? platformFees;
    String? platformFeesType;
    int? requiredServicemen;
    int? totalExtraServicemen;
    int? totalServicemen;
    int? totalExtraServicemenCharge;
    int? subtotal;
    double? total;
    DateTime? dateTime;
    int? bookingStatusId;
    String? paymentMethod;
    String? paymentStatus;
    dynamic description;
    String? invoiceUrl;
    int? createdById;
    DateTime? createdAt;
    Provider? provider;
    Service? service;
    List<dynamic>? servicemen;
    dynamic coupon;
    BookingStatus? bookingStatus;
    List<BookingStatusLog>? bookingStatusLogs;
    Consumer? consumer;
    Address? address;
    List<dynamic>? bookingReasons;
    List<dynamic>? serviceProofs;
    List<dynamic>? extraCharges;

    Datum({
        this.id,
        this.parentId,
        this.bookingNumber,
        this.consumerId,
        this.couponId,
        this.walletBalance,
        this.convertWalletBalance,
        this.providerId,
        this.serviceId,
        this.servicePackageId,
        this.addressId,
        this.servicePrice,
        this.tax,
        this.perServicemanCharge,
        this.couponTotalDiscount,
        this.platformFees,
        this.platformFeesType,
        this.requiredServicemen,
        this.totalExtraServicemen,
        this.totalServicemen,
        this.totalExtraServicemenCharge,
        this.subtotal,
        this.total,
        this.dateTime,
        this.bookingStatusId,
        this.paymentMethod,
        this.paymentStatus,
        this.description,
        this.invoiceUrl,
        this.createdById,
        this.createdAt,
        this.provider,
        this.service,
        this.servicemen,
        this.coupon,
        this.bookingStatus,
        this.bookingStatusLogs,
        this.consumer,
        this.address,
        this.bookingReasons,
        this.serviceProofs,
        this.extraCharges,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        parentId: json["parent_id"],
        bookingNumber: json["booking_number"],
        consumerId: json["consumer_id"],
        couponId: json["coupon_id"],
        walletBalance: json["wallet_balance"],
        convertWalletBalance: json["convert_wallet_balance"],
        providerId: json["provider_id"],
        serviceId: json["service_id"],
        servicePackageId: json["service_package_id"],
        addressId: json["address_id"],
        servicePrice: json["service_price"],
        tax: json["tax"]?.toDouble(),
        perServicemanCharge: json["per_serviceman_charge"],
        couponTotalDiscount: json["coupon_total_discount"],
        platformFees: json["platform_fees"],
        platformFeesType: json["platform_fees_type"],
        requiredServicemen: json["required_servicemen"],
        totalExtraServicemen: json["total_extra_servicemen"],
        totalServicemen: json["total_servicemen"],
        totalExtraServicemenCharge: json["total_extra_servicemen_charge"],
        subtotal: json["subtotal"],
        total: json["total"]?.toDouble(),
        dateTime: json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
        bookingStatusId: json["booking_status_id"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        description: json["description"],
        invoiceUrl: json["invoice_url"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        provider: json["provider"] == null ? null : Provider.fromJson(json["provider"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        servicemen: json["servicemen"] == null ? [] : List<dynamic>.from(json["servicemen"]!.map((x) => x)),
        coupon: json["coupon"],
        bookingStatus: json["booking_status"] == null ? null : BookingStatus.fromJson(json["booking_status"]),
        bookingStatusLogs: json["booking_status_logs"] == null ? [] : List<BookingStatusLog>.from(json["booking_status_logs"]!.map((x) => BookingStatusLog.fromJson(x))),
        consumer: json["consumer"] == null ? null : Consumer.fromJson(json["consumer"]),
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        bookingReasons: json["booking_reasons"] == null ? [] : List<dynamic>.from(json["booking_reasons"]!.map((x) => x)),
        serviceProofs: json["service_proofs"] == null ? [] : List<dynamic>.from(json["service_proofs"]!.map((x) => x)),
        extraCharges: json["extra_charges"] == null ? [] : List<dynamic>.from(json["extra_charges"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "booking_number": bookingNumber,
        "consumer_id": consumerId,
        "coupon_id": couponId,
        "wallet_balance": walletBalance,
        "convert_wallet_balance": convertWalletBalance,
        "provider_id": providerId,
        "service_id": serviceId,
        "service_package_id": servicePackageId,
        "address_id": addressId,
        "service_price": servicePrice,
        "tax": tax,
        "per_serviceman_charge": perServicemanCharge,
        "coupon_total_discount": couponTotalDiscount,
        "platform_fees": platformFees,
        "platform_fees_type": platformFeesType,
        "required_servicemen": requiredServicemen,
        "total_extra_servicemen": totalExtraServicemen,
        "total_servicemen": totalServicemen,
        "total_extra_servicemen_charge": totalExtraServicemenCharge,
        "subtotal": subtotal,
        "total": total,
        "date_time": dateTime?.toIso8601String(),
        "booking_status_id": bookingStatusId,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "description": description,
        "invoice_url": invoiceUrl,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "provider": provider?.toJson(),
        "service": service?.toJson(),
        "servicemen": servicemen == null ? [] : List<dynamic>.from(servicemen!.map((x) => x)),
        "coupon": coupon,
        "booking_status": bookingStatus?.toJson(),
        "booking_status_logs": bookingStatusLogs == null ? [] : List<dynamic>.from(bookingStatusLogs!.map((x) => x.toJson())),
        "consumer": consumer?.toJson(),
        "address": address?.toJson(),
        "booking_reasons": bookingReasons == null ? [] : List<dynamic>.from(bookingReasons!.map((x) => x)),
        "service_proofs": serviceProofs == null ? [] : List<dynamic>.from(serviceProofs!.map((x) => x)),
        "extra_charges": extraCharges == null ? [] : List<dynamic>.from(extraCharges!.map((x) => x)),
    };
}

class Address {
    int? id;
    int? userId;
    dynamic serviceId;
    int? isPrimary;
    dynamic latitude;
    dynamic longitude;
    String? area;
    String? postalCode;
    int? countryId;
    int? stateId;
    String? city;
    String? address;
    String? type;
    dynamic alternativeName;
    int? code;
    dynamic alternativePhone;
    int? status;
    dynamic companyId;
    dynamic availabilityRadius;
    Country? country;
    Country? state;

    Address({
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
        this.code,
        this.alternativePhone,
        this.status,
        this.companyId,
        this.availabilityRadius,
        this.country,
        this.state,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        isPrimary: json["is_primary"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        area: json["area"],
        postalCode: json["postal_code"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        city: json["city"],
        address: json["address"],
        type: json["type"],
        alternativeName: json["alternative_name"],
        code: json["code"],
        alternativePhone: json["alternative_phone"],
        status: json["status"],
        companyId: json["company_id"],
        availabilityRadius: json["availability_radius"],
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
        state: json["state"] == null ? null : Country.fromJson(json["state"]),
    );

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
        "code": code,
        "alternative_phone": alternativePhone,
        "status": status,
        "company_id": companyId,
        "availability_radius": availabilityRadius,
        "country": country?.toJson(),
        "state": state?.toJson(),
    };
}

class Country {
    int? id;
    String? name;

    Country({
        this.id,
        this.name,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class BookingStatus {
    int? id;
    String? name;
    String? slug;
    String? hexaCode;

    BookingStatus({
        this.id,
        this.name,
        this.slug,
        this.hexaCode,
    });

    factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        hexaCode: json["hexa_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "hexa_code": hexaCode,
    };
}

class BookingStatusLog {
    int? id;
    String? title;
    String? description;
    int? bookingId;
    int? bookingStatusId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Status? status;

    BookingStatusLog({
        this.id,
        this.title,
        this.description,
        this.bookingId,
        this.bookingStatusId,
        this.createdAt,
        this.updatedAt,
        this.status,
    });

    factory BookingStatusLog.fromJson(Map<String, dynamic> json) => BookingStatusLog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        bookingId: json["booking_id"],
        bookingStatusId: json["booking_status_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "booking_id": bookingId,
        "booking_status_id": bookingStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status?.toJson(),
    };
}

class Status {
    int? id;
    String? name;
    String? slug;
    int? sequence;
    dynamic description;
    int? createdById;
    int? systemReserve;
    String? hexaCode;
    int? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;

    Status({
        this.id,
        this.name,
        this.slug,
        this.sequence,
        this.description,
        this.createdById,
        this.systemReserve,
        this.hexaCode,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        sequence: json["sequence"],
        description: json["description"],
        createdById: json["created_by_id"],
        systemReserve: json["system_reserve"],
        hexaCode: json["hexa_code"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "sequence": sequence,
        "description": description,
        "created_by_id": createdById,
        "system_reserve": systemReserve,
        "hexa_code": hexaCode,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}

class Consumer {
    int? id;
    String? name;
    String? email;
    int? systemReserve;
    dynamic served;
    int? phone;
    int? code;
    dynamic providerId;
    int? status;
    int? isFeatured;
    int? isVerified;
    dynamic type;
    dynamic emailVerifiedAt;
    String? fcmToken;
    dynamic experienceInterval;
    dynamic experienceDuration;
    dynamic description;
    dynamic createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    dynamic companyId;
    int? bookingsCount;
    Role? role;
    dynamic reviewRatings;
    dynamic primaryAddress;
    dynamic servicemanReviewRatings;
    List<dynamic>? media;
    dynamic wallet;
    dynamic providerWallet;
    dynamic servicemanWallet;
    List<dynamic>? knownLanguages;
    List<dynamic>? expertise;
    List<dynamic>? zones;
    List<Role>? roles;
    List<dynamic>? reviews;
    List<dynamic>? servicemanreviews;

    Consumer({
        this.id,
        this.name,
        this.email,
        this.systemReserve,
        this.served,
        this.phone,
        this.code,
        this.providerId,
        this.status,
        this.isFeatured,
        this.isVerified,
        this.type,
        this.emailVerifiedAt,
        this.fcmToken,
        this.experienceInterval,
        this.experienceDuration,
        this.description,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.companyId,
        this.bookingsCount,
        this.role,
        this.reviewRatings,
        this.primaryAddress,
        this.servicemanReviewRatings,
        this.media,
        this.wallet,
        this.providerWallet,
        this.servicemanWallet,
        this.knownLanguages,
        this.expertise,
        this.zones,
        this.roles,
        this.reviews,
        this.servicemanreviews,
    });

    factory Consumer.fromJson(Map<String, dynamic> json) => Consumer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        systemReserve: json["system_reserve"],
        served: json["served"],
        phone: json["phone"],
        code: json["code"],
        providerId: json["provider_id"],
        status: json["status"],
        isFeatured: json["is_featured"],
        isVerified: json["is_verified"],
        type: json["type"],
        emailVerifiedAt: json["email_verified_at"],
        fcmToken: json["fcm_token"],
        experienceInterval: json["experience_interval"],
        experienceDuration: json["experience_duration"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        companyId: json["company_id"],
        bookingsCount: json["bookings_count"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        reviewRatings: json["review_ratings"],
        primaryAddress: json["primary_address"],
        servicemanReviewRatings: json["ServicemanReviewRatings"],
        media: json["media"] == null ? [] : List<dynamic>.from(json["media"]!.map((x) => x)),
        wallet: json["wallet"],
        providerWallet: json["provider_wallet"],
        servicemanWallet: json["serviceman_wallet"],
        knownLanguages: json["known_languages"] == null ? [] : List<dynamic>.from(json["known_languages"]!.map((x) => x)),
        expertise: json["expertise"] == null ? [] : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        zones: json["zones"] == null ? [] : List<dynamic>.from(json["zones"]!.map((x) => x)),
        roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        servicemanreviews: json["servicemanreviews"] == null ? [] : List<dynamic>.from(json["servicemanreviews"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "system_reserve": systemReserve,
        "served": served,
        "phone": phone,
        "code": code,
        "provider_id": providerId,
        "status": status,
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "type": type,
        "email_verified_at": emailVerifiedAt,
        "fcm_token": fcmToken,
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "company_id": companyId,
        "bookings_count": bookingsCount,
        "role": role?.toJson(),
        "review_ratings": reviewRatings,
        "primary_address": primaryAddress,
        "ServicemanReviewRatings": servicemanReviewRatings,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "wallet": wallet,
        "provider_wallet": providerWallet,
        "serviceman_wallet": servicemanWallet,
        "known_languages": knownLanguages == null ? [] : List<dynamic>.from(knownLanguages!.map((x) => x)),
        "expertise": expertise == null ? [] : List<dynamic>.from(expertise!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "servicemanreviews": servicemanreviews == null ? [] : List<dynamic>.from(servicemanreviews!.map((x) => x)),
    };
}

class Role {
    int? id;
    String? name;
    String? guardName;
    int? systemReserve;
    DateTime? createdAt;
    DateTime? updatedAt;
    RolePivot? pivot;

    Role({
        this.id,
        this.name,
        this.guardName,
        this.systemReserve,
        this.createdAt,
        this.updatedAt,
        this.pivot,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        systemReserve: json["system_reserve"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "system_reserve": systemReserve,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
    };
}

class RolePivot {
    String? modelType;
    int? modelId;
    int? roleId;

    RolePivot({
        this.modelType,
        this.modelId,
        this.roleId,
    });

    factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        modelType: json["model_type"],
        modelId: json["model_id"],
        roleId: json["role_id"],
    );

    Map<String, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
    };
}

class Provider {
    int? id;
    String? name;
    String? experienceInterval;
    int? experienceDuration;
    String? email;
    int? phone;
    String? fcmToken;
    int? code;
    Role? role;
    dynamic reviewRatings;
    Address? primaryAddress;
    dynamic servicemanReviewRatings;
    List<Media>? media;
    dynamic wallet;
    ProviderWallet? providerWallet;
    dynamic servicemanWallet;
    List<KnownLanguage>? knownLanguages;
    List<dynamic>? expertise;
    List<ProviderZone>? zones;
    List<Role>? roles;
    List<dynamic>? reviews;
    List<dynamic>? servicemanreviews;

    Provider({
        this.id,
        this.name,
        this.experienceInterval,
        this.experienceDuration,
        this.email,
        this.phone,
        this.fcmToken,
        this.code,
        this.role,
        this.reviewRatings,
        this.primaryAddress,
        this.servicemanReviewRatings,
        this.media,
        this.wallet,
        this.providerWallet,
        this.servicemanWallet,
        this.knownLanguages,
        this.expertise,
        this.zones,
        this.roles,
        this.reviews,
        this.servicemanreviews,
    });

    factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        name: json["name"],
        experienceInterval: json["experience_interval"],
        experienceDuration: json["experience_duration"],
        email: json["email"],
        phone: json["phone"],
        fcmToken: json["fcm_token"],
        code: json["code"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        reviewRatings: json["review_ratings"],
        primaryAddress: json["primary_address"] == null ? null : Address.fromJson(json["primary_address"]),
        servicemanReviewRatings: json["ServicemanReviewRatings"],
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        wallet: json["wallet"],
        providerWallet: json["provider_wallet"] == null ? null : ProviderWallet.fromJson(json["provider_wallet"]),
        servicemanWallet: json["serviceman_wallet"],
        knownLanguages: json["known_languages"] == null ? [] : List<KnownLanguage>.from(json["known_languages"]!.map((x) => KnownLanguage.fromJson(x))),
        expertise: json["expertise"] == null ? [] : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        zones: json["zones"] == null ? [] : List<ProviderZone>.from(json["zones"]!.map((x) => ProviderZone.fromJson(x))),
        roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        servicemanreviews: json["servicemanreviews"] == null ? [] : List<dynamic>.from(json["servicemanreviews"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "email": email,
        "phone": phone,
        "fcm_token": fcmToken,
        "code": code,
        "role": role?.toJson(),
        "review_ratings": reviewRatings,
        "primary_address": primaryAddress?.toJson(),
        "ServicemanReviewRatings": servicemanReviewRatings,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "wallet": wallet,
        "provider_wallet": providerWallet?.toJson(),
        "serviceman_wallet": servicemanWallet,
        "known_languages": knownLanguages == null ? [] : List<dynamic>.from(knownLanguages!.map((x) => x.toJson())),
        "expertise": expertise == null ? [] : List<dynamic>.from(expertise!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x.toJson())),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "servicemanreviews": servicemanreviews == null ? [] : List<dynamic>.from(servicemanreviews!.map((x) => x)),
    };
}

class KnownLanguage {
    String? key;
    int? id;
    KnownLanguagePivot? pivot;

    KnownLanguage({
        this.key,
        this.id,
        this.pivot,
    });

    factory KnownLanguage.fromJson(Map<String, dynamic> json) => KnownLanguage(
        key: json["key"],
        id: json["id"],
        pivot: json["pivot"] == null ? null : KnownLanguagePivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "id": id,
        "pivot": pivot?.toJson(),
    };
}

class KnownLanguagePivot {
    int? userId;
    int? languageId;

    KnownLanguagePivot({
        this.userId,
        this.languageId,
    });

    factory KnownLanguagePivot.fromJson(Map<String, dynamic> json) => KnownLanguagePivot(
        userId: json["user_id"],
        languageId: json["language_id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "language_id": languageId,
    };
}

class Media {
    int? id;
    String? modelType;
    int? modelId;
    String? uuid;
    String? collectionName;
    String? name;
    String? fileName;
    String? mimeType;
    String? disk;
    String? conversionsDisk;
    int? size;
    List<dynamic>? manipulations;
    List<dynamic>? customProperties;
    List<dynamic>? generatedConversions;
    List<dynamic>? responsiveImages;
    int? orderColumn;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? originalUrl;
    String? previewUrl;

    Media({
        this.id,
        this.modelType,
        this.modelId,
        this.uuid,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.conversionsDisk,
        this.size,
        this.manipulations,
        this.customProperties,
        this.generatedConversions,
        this.responsiveImages,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.originalUrl,
        this.previewUrl,
    });

    factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName: json["collection_name"],
        name: json["name"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        disk: json["disk"],
        conversionsDisk: json["conversions_disk"],
        size: json["size"],
        manipulations: json["manipulations"] == null ? [] : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        customProperties: json["custom_properties"] == null ? [] : List<dynamic>.from(json["custom_properties"]!.map((x) => x)),
        generatedConversions: json["generated_conversions"] == null ? [] : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null ? [] : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": collectionName,
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "disk": disk,
        "conversions_disk": conversionsDisk,
        "size": size,
        "manipulations": manipulations == null ? [] : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties == null ? [] : List<dynamic>.from(customProperties!.map((x) => x)),
        "generated_conversions": generatedConversions == null ? [] : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null ? [] : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
    };
}

class ProviderWallet {
    int? id;
    int? providerId;
    int? balance;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;

    ProviderWallet({
        this.id,
        this.providerId,
        this.balance,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory ProviderWallet.fromJson(Map<String, dynamic> json) => ProviderWallet(
        id: json["id"],
        providerId: json["provider_id"],
        balance: json["balance"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "balance": balance,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}

class ProviderZone {
    int? id;
    String? name;
    PlacePoints? placePoints;
    List<Location>? locations;
    String? status;
    int? createdById;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    PurplePivot? pivot;

    ProviderZone({
        this.id,
        this.name,
        this.placePoints,
        this.locations,
        this.status,
        this.createdById,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.pivot,
    });

    factory ProviderZone.fromJson(Map<String, dynamic> json) => ProviderZone(
        id: json["id"],
        name: json["name"],
        placePoints: json["place_points"] == null ? null : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : PurplePivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place_points": placePoints?.toJson(),
        "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
    };
}

class Location {
    double? lat;
    double? lng;

    Location({
        this.lat,
        this.lng,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class PurplePivot {
    int? providerId;
    int? zoneId;

    PurplePivot({
        this.providerId,
        this.zoneId,
    });

    factory PurplePivot.fromJson(Map<String, dynamic> json) => PurplePivot(
        providerId: json["provider_id"],
        zoneId: json["zone_id"],
    );

    Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "zone_id": zoneId,
    };
}

class PlacePoints {
    String? type;
    List<List<List<double>>>? coordinates;

    PlacePoints({
        this.type,
        this.coordinates,
    });

    factory PlacePoints.fromJson(Map<String, dynamic> json) => PlacePoints(
        type: json["type"],
        coordinates: json["coordinates"] == null ? [] : List<List<List<double>>>.from(json["coordinates"]!.map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x?.toDouble())))))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
    };
}

class Service {
    int? id;
    String? title;
    int? price;
    int? status;
    String? duration;
    String? durationUnit;
    int? serviceRate;
    int? discount;
    dynamic perServicemanCommission;
    String? description;
    dynamic specialityDescription;
    int? userId;
    String? type;
    int? isFeatured;
    int? requiredServicemen;
    dynamic metaTitle;
    String? slug;
    dynamic metaDescription;
    int? createdById;
    int? isRandomRelatedServices;
    int? taxId;
    dynamic deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic serviceType;
    int? bookingsCount;
    int? reviewsCount;
    List<int>? reviewRatings;
    dynamic ratingCount;
    List<Category>? categories;
    List<Media>? media;
    List<dynamic>? reviews;

    Service({
        this.id,
        this.title,
        this.price,
        this.status,
        this.duration,
        this.durationUnit,
        this.serviceRate,
        this.discount,
        this.perServicemanCommission,
        this.description,
        this.specialityDescription,
        this.userId,
        this.type,
        this.isFeatured,
        this.requiredServicemen,
        this.metaTitle,
        this.slug,
        this.metaDescription,
        this.createdById,
        this.isRandomRelatedServices,
        this.taxId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.serviceType,
        this.bookingsCount,
        this.reviewsCount,
        this.reviewRatings,
        this.ratingCount,
        this.categories,
        this.media,
        this.reviews,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        status: json["status"],
        duration: json["duration"],
        durationUnit: json["duration_unit"],
        serviceRate: json["service_rate"],
        discount: json["discount"],
        perServicemanCommission: json["per_serviceman_commission"],
        description: json["description"],
        specialityDescription: json["speciality_description"],
        userId: json["user_id"],
        type: json["type"],
        isFeatured: json["is_featured"],
        requiredServicemen: json["required_servicemen"],
        metaTitle: json["meta_title"],
        slug: json["slug"],
        metaDescription: json["meta_description"],
        createdById: json["created_by_id"],
        isRandomRelatedServices: json["is_random_related_services"],
        taxId: json["tax_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        serviceType: json["service_type"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        reviewRatings: json["review_ratings"] == null ? [] : List<int>.from(json["review_ratings"]!.map((x) => x)),
        ratingCount: json["rating_count"],
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "status": status,
        "duration": duration,
        "duration_unit": durationUnit,
        "service_rate": serviceRate,
        "discount": discount,
        "per_serviceman_commission": perServicemanCommission,
        "description": description,
        "speciality_description": specialityDescription,
        "user_id": userId,
        "type": type,
        "is_featured": isFeatured,
        "required_servicemen": requiredServicemen,
        "meta_title": metaTitle,
        "slug": slug,
        "meta_description": metaDescription,
        "created_by_id": createdById,
        "is_random_related_services": isRandomRelatedServices,
        "tax_id": taxId,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service_type": serviceType,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "review_ratings": reviewRatings == null ? [] : List<dynamic>.from(reviewRatings!.map((x) => x)),
        "rating_count": ratingCount,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
    };
}

class Category {
    int? id;
    String? title;
    String? slug;
    String? description;
    int? parentId;
    dynamic metaTitle;
    dynamic metaDescription;
    int? commission;
    int? status;
    int? isFeatured;
    String? categoryType;
    int? createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    CategoryPivot? pivot;
    List<Media>? media;
    List<CategoryZone>? zones;

    Category({
        this.id,
        this.title,
        this.slug,
        this.description,
        this.parentId,
        this.metaTitle,
        this.metaDescription,
        this.commission,
        this.status,
        this.isFeatured,
        this.categoryType,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.pivot,
        this.media,
        this.zones,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        parentId: json["parent_id"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        commission: json["commission"],
        status: json["status"],
        isFeatured: json["is_featured"],
        categoryType: json["category_type"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : CategoryPivot.fromJson(json["pivot"]),
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        zones: json["zones"] == null ? [] : List<CategoryZone>.from(json["zones"]!.map((x) => CategoryZone.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "parent_id": parentId,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "commission": commission,
        "status": status,
        "is_featured": isFeatured,
        "category_type": categoryType,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x.toJson())),
    };
}

class CategoryPivot {
    int? serviceId;
    int? categoryId;

    CategoryPivot({
        this.serviceId,
        this.categoryId,
    });

    factory CategoryPivot.fromJson(Map<String, dynamic> json) => CategoryPivot(
        serviceId: json["service_id"],
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "category_id": categoryId,
    };
}

class CategoryZone {
    int? id;
    String? name;
    PlacePoints? placePoints;
    List<Location>? locations;
    String? status;
    int? createdById;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    FluffyPivot? pivot;

    CategoryZone({
        this.id,
        this.name,
        this.placePoints,
        this.locations,
        this.status,
        this.createdById,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.pivot,
    });

    factory CategoryZone.fromJson(Map<String, dynamic> json) => CategoryZone(
        id: json["id"],
        name: json["name"],
        placePoints: json["place_points"] == null ? null : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : FluffyPivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place_points": placePoints?.toJson(),
        "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
    };
}

class FluffyPivot {
    int? categoryId;
    int? zoneId;

    FluffyPivot({
        this.categoryId,
        this.zoneId,
    });

    factory FluffyPivot.fromJson(Map<String, dynamic> json) => FluffyPivot(
        categoryId: json["category_id"],
        zoneId: json["zone_id"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "zone_id": zoneId,
    };
}

class Link {
    String? url;
    String? label;
    bool? active;

    Link({
        this.url,
        this.label,
        this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}

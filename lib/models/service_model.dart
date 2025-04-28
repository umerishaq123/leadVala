import '../config.dart';

class Services {
  int? id;
  String? title;
  double? price;
  int? status;
  String? duration;
  String? durationUnit;
  double? serviceRate;
  int? discount;
  String? description;
  int? userId;
  String? type;
  int? isFeatured;
  int? requiredServicemen;
  String? isMultipleServiceman;
  String? metaDescription;
  String? selectServiceManType;
  DateTime? serviceDate;
  List<int>? reviewRatings;
  int? ratingCount;
  List<CategoryModel>? categories;
  List<Services>? relatedServices;
  List<Media>? media;
  ProviderModel? user;

  PrimaryAddress? primaryAddress; // ✅ Added for safety
  List<Reviews>? reviews;
  List<ProviderModel>? selectedServiceMan; // ✅ Fixed parameter
  int? selectedRequiredServiceMan;
  String? selectDateTimeOption;
  String? selectedDateTimeFormat;
  String? selectedServiceNote;

  // Newly added fields
  String? serviceType;
  String? audio;
  String? typeOfTenant;
  double? budget;
  String? phoneNumber;
  String? mainarea;
  Services(
      {this.id,
      this.title,
      this.price,
      this.status,
      this.duration,
      this.durationUnit,
      this.serviceRate,
      this.discount,
      this.description,
      this.userId,
      this.type,
      this.isFeatured,
      this.requiredServicemen,
      this.isMultipleServiceman,
      this.metaDescription,
      this.selectServiceManType,
      this.serviceDate,
      this.reviewRatings,
      this.ratingCount,
      this.categories,
      this.relatedServices,
      this.media,
      this.user,
      this.primaryAddress, // ✅ Ensure it's included
      this.reviews,
      this.selectedRequiredServiceMan,
      this.selectDateTimeOption,
      this.selectedDateTimeFormat,
      this.selectedServiceNote,
      this.selectedServiceMan, // ✅ Add to Constructor

      this.serviceType,
      this.audio,
      this.typeOfTenant,
      this.budget,
      this.phoneNumber,
      this.mainarea});

  /// ✅ **Safe JSON Parsing**
  factory Services.fromJson(Map<String, dynamic> json) {
    print("🟢 Parsing Service ID: ${json['id']}");

    return Services(
      id: json['id'] ?? 0,
      title: json['title'] ?? "Unknown Title",
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      status: json['status'] ?? 0,
      duration: json['duration'] ?? "N/A",
      durationUnit: json['duration_unit'] ?? "N/A",
      serviceRate: json['service_rate'] != null
          ? double.tryParse(json['service_rate'].toString()) ?? 0.0
          : 0.0,
      discount: json['discount'] ?? 0,
      description: json['description'] ?? "No description available",
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? "Unknown",
      isFeatured: json['is_featured'] ?? 0,
      requiredServicemen: json['required_servicemen'] ?? 0,
      isMultipleServiceman: json['isMultipleServiceman'] ?? "false",
      metaDescription: json['meta_description'] ?? "N/A",
      selectServiceManType: json['selectServiceManType'] ?? "auto",
      serviceDate: json["serviceDate"] != null
          ? DateTime.tryParse(json["serviceDate"])
          : null,
      reviewRatings: json['review_ratings']?.cast<int>() ?? [],
      ratingCount: json['rating_count'] ?? 0,
      selectedRequiredServiceMan: json['required_servicemen'] ?? 1,
      selectDateTimeOption: json['selectDateTimeOption'] ?? "auto",
      selectedDateTimeFormat: json['selectedDateTimeFormat'] ?? "N/A",
      selectedServiceNote: json['selectedServiceNote'] ?? "N/A",
      serviceType: json['service_type'] ?? "N/A",
      audio: json['audio'] ?? "",
      typeOfTenant: json['type_of_tenant'] ?? "N/A",
      budget: json['budget'] != null
          ? double.tryParse(json['budget'].toString()) ?? 0.0
          : 0.0,
      phoneNumber: json['phone_number'] ?? "N/A",
      mainarea: json['main_area'] ?? "N/A",

      /// ✅ **Handle Nested Objects**
      categories: (json['categories'] as List?)
              ?.map((v) => CategoryModel.fromJson(v))
              .toList() ??
          [],
      relatedServices: (json['related_services'] as List?)
              ?.map((v) => Services.fromJson(v))
              .toList() ??
          [],
      media: (json['media'] as List?)?.map((v) => Media.fromJson(v)).toList() ??
          [],
      user: json['user'] != null ? ProviderModel.fromJson(json['user']) : null,

      /// ✅ **Extract Primary Address from User Safely**
      primaryAddress:
          json['user'] != null && json['user']['primary_address'] != null
              ? PrimaryAddress.fromJson(json['user']['primary_address'])
              : null, // Returns null if missing

      reviews: (json['reviews'] as List?)
              ?.map((v) => Reviews.fromJson(v))
              .toList() ??
          [],
      selectedServiceMan: (json['selectedServiceMan'] as List?)
              ?.map((v) => ProviderModel.fromJson(v))
              .toList() ??
          [],
    );
  }

  /// ✅ **Safe toJson()**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "status": status,
      "duration": duration,
      "duration_unit": durationUnit,
      "service_rate": serviceRate,
      "discount": discount,
      "description": description,
      "user_id": userId,
      "type": type,
      "is_featured": isFeatured,
      "required_servicemen": requiredServicemen,
      "isMultipleServiceman": isMultipleServiceman,
      "meta_description": metaDescription,
      "selectServiceManType": selectServiceManType,
      "serviceDate": serviceDate?.toIso8601String(),
      "review_ratings": reviewRatings,
      "rating_count": ratingCount,
      "selectedRequiredServiceMan": selectedRequiredServiceMan,
      "selectDateTimeOption": selectDateTimeOption,
      "selectedDateTimeFormat": selectedDateTimeFormat,
      "selectedServiceNote": selectedServiceNote,
      "service_type": serviceType,
      "audio": audio,
      "type_of_tenant": typeOfTenant,
      "budget": budget,
      "phone_number": phoneNumber,
      "main_area": mainarea,
      "selectedServiceMan":
          selectedServiceMan?.map((v) => v.toJson()).toList(), // ✅ Fixed
      // ✅ Ensure it converts safely
    };
  }
}

/*
class Services {
  int? id;
  String? title;
  double? price;
  int? status;
  String? duration;
  String? durationUnit;
  double? serviceRate;
  int? discount;
  String? description;
  int? userId;
  String? type;
  int? isFeatured;
  int? requiredServicemen;
  String? isMultipleServiceman;
  String? metaDescription;
  String? selectServiceManType;
  DateTime? serviceDate;
  List<int>? reviewRatings;
  int? ratingCount;
  List<CategoryModel>? categories;
  List<Services>? relatedServices;
  List<Media>? media;
  ProviderModel? user;
  List<Reviews>? reviews;
  List<ProviderModel>? selectedServiceMan;
  int? selectedRequiredServiceMan;
  String? selectDateTimeOption;
  String? selectedDateTimeFormat;
  String? selectedServiceNote;
  PrimaryAddress? primaryAddress;

  // Newly added fields
  String? serviceType;
  String? audio;
  String? typeOfTenant;
  double? budget;
  String? phoneNumber;

  Services({
    this.id,
    this.title,
    this.price,
    this.status,
    this.duration,
    this.durationUnit,
    this.serviceRate,
    this.discount,
    this.description,
    this.userId,
    this.type,
    this.isFeatured,
    this.requiredServicemen,
    this.isMultipleServiceman,
    this.metaDescription,
    this.selectServiceManType,
    this.serviceDate,
    this.reviewRatings,
    this.ratingCount,
    this.categories,
    this.relatedServices,
    this.media,
    this.user,
    this.reviews,
    this.selectedRequiredServiceMan,
    this.primaryAddress,
    this.selectDateTimeOption,
    this.selectedDateTimeFormat,
    this.selectedServiceNote,
    this.serviceType,
    this.audio,
    this.typeOfTenant,
    this.budget,
    this.phoneNumber,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    status = json['status'];
    duration = json['duration'];
    durationUnit = json['duration_unit'];
    serviceRate = json['service_rate'] != null
        ? double.parse(json['service_rate'].toString())
        : null;
    discount = json['discount'];
    description = json['description'];
    userId = json['user_id'];
    type = json['type'];
    isFeatured = json['is_featured'];
    requiredServicemen = json['required_servicemen'];
    isMultipleServiceman = json['isMultipleServiceman'];
    metaDescription = json['meta_description'];
    selectServiceManType = json['selectServiceManType'];
    serviceDate = json["serviceDate"] == null
        ? null
        : DateTime.parse(json["serviceDate"]);
    reviewRatings = json['review_ratings'].cast<int>();
    ratingCount = json['rating_count'];
    selectedRequiredServiceMan = json['required_servicemen'] ?? "1";
    selectDateTimeOption = json['selectDateTimeOption'];
    selectedDateTimeFormat = json['selectedDateTimeFormat'];
    selectedServiceNote = json['selectedServiceNote'];
    serviceType = json['service_type'];
    audio = json['audio'];
    typeOfTenant = json['type_of_tenant'];
    budget =
        json['budget'] != null ? double.parse(json['budget'].toString()) : null;
    phoneNumber = json['phone_number'];

    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['related_services'] != null) {
      relatedServices = <Services>[];
      json['related_services'].forEach((v) {
        relatedServices!.add(Services.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    user = json['user'] != null ? ProviderModel.fromJson(json['user']) : null;
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['selectedServiceMan'] != null) {
      selectedServiceMan = <ProviderModel>[];
      json['selectedServiceMan'].forEach((v) {
        selectedServiceMan!.add(ProviderModel.fromJson(v));
      });
    }
  }


  get serviceName => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['status'] = status;
    data['duration'] = duration;
    data['duration_unit'] = durationUnit;
    data['service_rate'] = serviceRate;
    data['discount'] = discount;
    data['description'] = description;
    data['user_id'] = userId;
    data['type'] = type;
    data['is_featured'] = isFeatured;
    data['required_servicemen'] = requiredServicemen;
    data['isMultipleServiceman'] = isMultipleServiceman;
    data['meta_description'] = metaDescription;
    data['selectServiceManType'] = selectServiceManType;
    data['serviceDate'] =
        serviceDate == null ? null : serviceDate!.toIso8601String();
    data['review_ratings'] = reviewRatings;
    data['rating_count'] = ratingCount;
    data['selectedRequiredServiceMan'] = selectedRequiredServiceMan;
    data['selectDateTimeOption'] = selectDateTimeOption;
    data['selectedDateTimeFormat'] = selectedDateTimeFormat;
    data['selectedServiceNote'] = selectedServiceNote;
    data['service_type'] = serviceType;
    data['audio'] = audio;
    data['type_of_tenant'] = typeOfTenant;
    data['budget'] = budget;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

*/
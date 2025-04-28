class NotificationModel {
  dynamic id; // ✅ Handle both int and String
  String? type;
  String? notifiableType;
  dynamic notifiableId; // ✅ Handle both int and String
  NotificationData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(), // ✅ Convert int to String safely
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId:
          json['notifiable_id']?.toString(), // ✅ Convert int to String safely
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      readAt: json['read_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'data': data?.toJson(),
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class NotificationData {
  String? title;
  String? message;
  dynamic providerId;
  dynamic bookingId;
  dynamic serviceId;
  String? type;
  String? thumbnail;
  String? image;

  NotificationData({
    this.title,
    this.message,
    this.providerId,
    this.bookingId,
    this.serviceId,
    this.type,
    this.thumbnail,
    this.image,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      message: json['message'],
      providerId:
          json['provider_id']?.toString(), // ✅ Convert int to String safely
      bookingId:
          json['booking_id']?.toString(), // ✅ Convert int to String safely
      serviceId:
          json['service_id']?.toString(), // ✅ Convert int to String safely
      type: json['type'],
      thumbnail: json['thumbnail'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'provider_id': providerId,
      'booking_id': bookingId,
      'service_id': serviceId,
      'type': type,
      'thumbnail': thumbnail,
      'image': image,
    };
  }
}

/*
class NotificationModel {
  String? id;
  String? type;
  String? notifiableType;
  String? notifiableId;
  NotificationData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data =
        json['data'] != null ? NotificationData.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['notifiable_type'] = notifiableType;
    data['notifiable_id'] = notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class NotificationData {
  String? title;
  String? message;
  int? providerId;
  int? bookingId;
  int? serviceId;
  String? type;
  String? thumbnail;
  String? image;

  NotificationData(
      {this.title,
      this.message,
      this.providerId,
      this.type,
      this.image,
      this.thumbnail,
      this.bookingId,
      this.serviceId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    providerId = json['provider_id'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    type = json['type'];
    thumbnail = json['thumbnail'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['message'] = message;
    data['provider_id'] = providerId;
    data['booking_id'] = bookingId;
    data['service_id'] = serviceId;
    data['type'] = type;
    data['thumbnail'] = thumbnail;
    data['image'] = image;

    return data;
  }
}
*/
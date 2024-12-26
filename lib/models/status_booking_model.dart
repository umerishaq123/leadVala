class StatusBookingModel {
  String? image;
  String? bookingId;
  String? status;
  String? title;
  String? rate;
  String? date;
  String? time;
  String? location;
  String? description;
  List<ProviderList>? providerList;
  List<ServicemanList>? servicemanList;

  StatusBookingModel(
      {this.image,
        this.bookingId,
        this.title,
        this.rate,
        this.status,
        this.date,
        this.time,
        this.location,
        this.description,
        this.providerList,
        this.servicemanList});

  StatusBookingModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    bookingId = json['bookingId']?.toString();
    title = json['title'];
    rate = json['rate'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    description = json['description'];
    if (json['providerList'] != null) {
      providerList = <ProviderList>[];
      json['providerList'].forEach((v) {
        providerList!.add(ProviderList.fromJson(v));
      });
    }
    if (json['servicemanList'] != null) {
      servicemanList = <ServicemanList>[];
      json['servicemanList'].forEach((v) {
        servicemanList!.add(ServicemanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['bookingId'] = bookingId;
    data['title'] = title;
    data['rate'] = rate;
    data['status'] = status;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['description'] = description;
    if (providerList != null) {
      data['providerList'] = providerList!.map((v) => v.toJson()).toList();
    }
    if (servicemanList != null) {
      data['servicemanList'] =
          servicemanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderList {
  String? role;
  String? image;
  String? title;
  String? rate;
  String? experience;
  String? email;
  String? phone;
  String? location;

  ProviderList(
      {this.role,
        this.image,
        this.title,
        this.rate,
        this.experience,
        this.email,
        this.phone,
        this.location});

  ProviderList.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    image = json['image'];
    title = json['title'];
    rate = json['rate'];
    experience = json['experience'];
    email = json['email'];
    phone = json['phone'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['image'] = image;
    data['title'] = title;
    data['rate'] = rate;
    data['experience'] = experience;
    data['email'] = email;
    data['phone'] = phone;
    data['location'] = location;
    return data;
  }
}

class ServicemanList {
  String? role;
  String? image;
  String? title;
  String? rate;
  String? experience;

  ServicemanList({this.role, this.image, this.title, this.rate});

  ServicemanList.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    image = json['image'];
    title = json['title'];
    rate = json['rate'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['role'] = role;
    data['image'] = image;
    data['title'] = title;
    data['rate'] = rate;
    data['experience'] = experience;
    return data;
  }
}

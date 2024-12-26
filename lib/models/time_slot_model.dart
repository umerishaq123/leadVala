class TimeSlotModel {
  int? id;
  List<TimeSlots>? timeSlots;
  String? gap;
  String? timeUnit;
  String? providerId;
  String? servicemanId;

  TimeSlotModel(
      {this.id,
        this.timeSlots,
        this.gap,
        this.timeUnit,
        this.providerId,
        this.servicemanId});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['time_slots'] != null) {
      timeSlots = <TimeSlots>[];
      json['time_slots'].forEach((v) {
        timeSlots!.add(TimeSlots.fromJson(v));
      });
    }
    gap = json['gap']?.toString();
    timeUnit = json['time_unit'];
    providerId = json['provider_id']?.toString();
    servicemanId = json['serviceman_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (timeSlots != null) {
      data['time_slots'] = timeSlots!.map((v) => v.toJson()).toList();
    }
    data['gap'] = gap;
    data['time_unit'] = timeUnit;
    data['provider_id'] = providerId;
    data['serviceman_id'] = servicemanId;
    return data;
  }
}

class TimeSlots {
  String? day;
  String? status;
  String? endTime;
  String? startTime;

  TimeSlots(
      {this.day, this.status, this.endTime, this.startTime});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    status = json['status']?.toString();
    endTime = json['end_time'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['status'] = status;
    data['end_time'] = endTime;
    data['start_time'] = startTime;
    return data;
  }
}

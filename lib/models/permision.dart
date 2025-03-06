class Permission {
  int? id;
  String? name;
  String? guardName;

  Permission({this.id, this.name, this.guardName});

  Permission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
    };
  }
}

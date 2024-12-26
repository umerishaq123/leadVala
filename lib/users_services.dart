

import 'package:leadvala/models/address_model.dart';
import 'package:leadvala/models/service_model.dart';
import 'package:leadvala/models/user_model.dart';
import 'package:leadvala/packages_list.dart';

UserModel? userModel;

PrimaryAddress? userPrimaryAddress;

String? currentAddress, street;

LatLng? position;

String zoneIds ="";

int? setPrimaryAddress;

List<Services> servicePackageList = [];
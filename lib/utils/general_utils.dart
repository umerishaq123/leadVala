import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:leadvala/config.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';

Color colorCondition(String? text, context) {
  if (text == appFonts.pending) {
    return appColor(context).pending;
  } else if (text == appFonts.accepted || text == appFonts.assigned) {
    return appColor(context).accepted;
  } else if (text == appFonts.onGoing ||
      text == appFonts.onHold ||
      text == appFonts.startAgain) {
    return appColor(context).ongoing;
  } else if (text == appFonts.cancel) {
    return appColor(context).red;
  } else if (text == appFonts.onHold) {
    return appColor(context).red;
  } else {
    return appColor(context).primary;
  }
}

Color colorConditionById(String? text, context) {
  final dash = Provider.of<DashboardProvider>(context, listen: false);
  int index = dash.bookingStatusList
      .indexWhere((element) => element.id.toString() == text);
  if (index > 0) {
    if (dash.bookingStatusList[index].slug == appFonts.pending) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else if (dash.bookingStatusList[index].slug == appFonts.accepted ||
        dash.bookingStatusList[index].slug == appFonts.assigned) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else if (dash.bookingStatusList[index].slug == appFonts.onGoing) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else if (dash.bookingStatusList[index].slug == appFonts.cancel) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else if (dash.bookingStatusList[index].slug == appFonts.assigned) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else if (dash.bookingStatusList[index].slug == appFonts.onHold) {
      return Color(int.parse(
          "0xFF${dash.bookingStatusList[index].hexaCode!.split("#")[1]}"));
    } else {
      return appColor(context).primary;
    }
  } else {
    return appColor(context).pending;
  }
}

String monthCondition(String? text) {
  if (text == '1') {
    return "JAN";
  } else if (text == '2') {
    return "FEB";
  } else if (text == '3') {
    return "MAR";
  } else if (text == '4') {
    return "APR";
  } else if (text == '5') {
    return "MAY";
  } else if (text == '6') {
    return "JUN";
  } else if (text == '7') {
    return "JUL";
  } else if (text == '8') {
    return "AUG";
  } else if (text == '9') {
    return "SEP";
  } else if (text == '10') {
    return "OCT";
  } else if (text == "11") {
    return "NOV";
  } else if (text == '12') {
    return "DEC";
  } else {
    return "JAN";
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Future<bool> isNetworkConnection() async {
  var connectivityResult = await Connectivity()
      .checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup(
        'google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

String? getDistance(context, lat1, long1) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((double.parse(lat1) - position!.latitude) * p) / 2 +
      c(double.parse(lat1) * p) *
          c(double.parse(long1) * p) *
          (1 - c((double.parse(long1) - position!.longitude) * p)) /
          2;
  return (12742 * asin(sqrt(a))).toStringAsPrecision(1).toString();
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();

  /// String v = hexString.replaceAll("#", "0xFF");
  //buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(hexString.substring(1, hexString.length), radix: 16) +
      0xFF000000);
}

// getFcmToken() async {
//   print('fasttimecall');
//   String? token;
//   token = await FirebaseMessaging.instance.getToken();
//   print('fcm token t0 firebase chacek ++ $token');
//   print('fcm token t0 firebase chacek ++ $token');
//   return token;
// }

Future<String?> getFcmToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (for web and iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("❌ Permission Denied for Notifications");
      return null;
    }

    String? token;

    // Web needs VAPID key
    if (kIsWeb) {
      token = await messaging.getToken(
        vapidKey:
            "BJndSyPX5NuP9SyMR8B79QAMtGm0HTkoVujQKa27G_OVhlhNqrVKflSf4kRtDyQdQuXgIY7fu4Ghh9SbI9OHRAA", // ⚠️ Must add this from Firebase
      );
      print('web fcm token????///  $token  ????///');
    } else {
      token = await messaging.getToken();
      print('app file  fcm token  $token');
    }

    if (token != null) {
      print("✅ FCM Token Retrieved: $token");
    } else {
      print("⚠️ Token is null");
    }

    return token;
  } catch (e) {
    print("🚨 Error retrieving FCM Token: $e");
    return null;
  }
}

/*
getFcmToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("❌ Permission Denied for Notifications");
      return null;
    }

    // Get FCM Token
    String? token = await messaging.getToken();

    if (token != null) {
      print("✅ eFCM Token Retrieved: $token ..>>>>????///");
    } else {
      print("⚠️ Failed to retrieve FCM Token.");
    }

    return token;
  } catch (e) {
    print("🚨 Error retrieving FCM Token: $e");
    return null;
  }
}
*/
// getFcmToken() async {
//   try {
//     print('🔄 Fetching FCM Token...');

//     // Ensure Firebase Messaging is initialized
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     // Request permission (for iOS & Web)
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       print('❌ FCM Permission Denied');
//       return null;
//     }

//     // Get the FCM Token
//     String? token = await messaging.getToken();
//     if (token != null) {
//       print('✅ FCM Token Retrieved: $token');
//     } else {
//       print('⚠️ Failed to retrieve FCM Token.');
//     }

//     return token;
//   } catch (e) {
//     print('🚨 Error retrieving FCM Token: $e');
//     return null;
//   }
// }

getTime(time) {
  if (!DateTime.now().difference(time).isNegative) {
    if (DateTime.now().difference(time).inMinutes < 1) {
      return "a few seconds ago";
    } else if (DateTime.now().difference(time).inMinutes < 60) {
      return "${DateTime.now().difference(time).inMinutes} minutes ago";
    } else if (DateTime.now().difference(time).inMinutes < 1440) {
      return "${DateTime.now().difference(time).inHours} hours ago";
    } else if (DateTime.now().difference(time).inMinutes > 1440) {
      return DateFormat('dd MMM, yyyy').format(time);
    }
  }
}

slots(start, end, gap) {
  String startTime = start;
  String space = gap;
  DateTime date = DateFormat.jm().parse(end);
  String closeTime = DateFormat("HH:mm").format(date);
  int? startTimeInMinutes = _getTimeInMinutesSinceMidnight(startTime, false);
  int? closeTimeInMinutes = _getTimeInMinutesSinceMidnight(closeTime, false);
  int? spaceInMinutes = _getTimeInMinutesSinceMidnight(space, true);

  if (startTimeInMinutes == null ||
      closeTimeInMinutes == null ||
      spaceInMinutes == null) {
    return;
  }

  List<String> slotsList = [];
  for (int i = startTimeInMinutes;
      i <= closeTimeInMinutes;
      i += spaceInMinutes) {
    slotsList.add(_getTimeInStringForMinutesSinceMidnight(i));
  }

  return slotsList;
}

int? _getTimeInMinutesSinceMidnight(String time, isCount) {
  final parts = time.split(":");

  if (parts.length != 2 && parts.length != 3) {
    return null;
  }

  final a = int.tryParse(parts[0]);
  final b = int.tryParse(parts[1]);

  if (a == null || b == null) {
    return null;
  }

  return a * 60 + b;
}

String _getTimeInStringForMinutesSinceMidnight(int time) {
  final hours = time ~/ 60;
  final minutes = time % 60;

  formatTime(int val) {
    if (val < 10) {
      return "0$val";
    } else {
      return "$val";
    }
  }

  return "${formatTime(hours)}:${formatTime(minutes)}";
}

isServiceEmpty(List<Services> list) {
  bool isAnyEmpty = false;
  list.asMap().entries.forEach((element) {
    if (element.value.selectServiceManType == "app_choose") {
      isAnyEmpty = true;
    }
  });
  return isAnyEmpty;
}

isServiceManEmpty(List<Services> list) {
  List<ProviderModel> provider = [];

  for (var data in list) {
    if (data.selectedServiceMan != null &&
        data.selectedServiceMan!.isNotEmpty) {
      data.selectedServiceMan!.asMap().entries.forEach((element) {
        provider.add(element.value);
      });
    }
  }

  return provider;
}

getName(List<CartModel> cart, id, isPackage) {
  String name = "";
  for (var list in cart) {
    if (list.isPackage == false) {
      if (list.serviceList!.id == id) {
        name = list.serviceList!.title!;
        return name;
      }
    } else {
      for (var pack in list.servicePackageList!.services!) {
        if (pack.id == id) {
          name = pack.title!;
          return name;
        }
      }
    }
  }
  return name;
}

getTotalRequiredServiceMan(
  List<CartModel> cart,
  id,
  isPackage,
) {
  print('gettotalRequiredservieman');
  print('gettotalRequiredservieman${id}');

  int count = 0;
  for (var list in cart) {
    if (list.isPackage == false) {
      if (list.serviceList!.id == id) {
        count = (list.serviceList!.selectedRequiredServiceMan!);
        return count;
      }
    } else {
      for (var pack in list.servicePackageList!.services!) {
        if (pack.id == id) {
          count = (pack.selectedRequiredServiceMan!);
          return count;
        }
      }
    }
  }
  return count;
}

bool isInCart(context, id) {
  final cart = Provider.of<CartProvider>(context, listen: false);
  return cart.cartList
      .where((element) =>
          element.isPackage == false && element.serviceList!.id == id)
      .isNotEmpty;
}

bookingReasons(List<BookingReasons> bookingReasons) {
  String reason = "";
  bookingReasons.asMap().entries.forEach((e) {
    if (e.value.status!.name == appFonts.cancelled ||
        e.value.status!.name == appFonts.cancel) {
      reason = e.value.reason!;
    }
  });
  return reason;
}

bool isServiceRate(List<Reviews> review) {
  print("LENG :${review.length} ");
  bool isNotComplete = false;

  int index =
      review.indexWhere((element) => element.consumerId == userModel!.id);
  if (index >= 0) {
    isNotComplete = true;
  } else {
    isNotComplete = false;
  }
  return isNotComplete;
}

getDate(date) {
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'Today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'Yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

bool isPaymentComplete(BookingModel value) {
  bool isPayment = false;

  if (value.paymentMethod == "cash") {
    isPayment = true;
  } else {
    if (value.extraCharges != null && value.extraCharges!.isNotEmpty) {
      /*bool isNotComplete = value.extraCharges!
          .where(
              (element) => element.paymentMethod == null)
          .isNotEmpty;
      if (isNotComplete) {
        isPayment = true;
      } else {
        isPayment = false;
      }*/
      for (var d in value.extraCharges!) {
        if (d.paymentStatus == null ||
            d.paymentStatus!.toLowerCase() == "pending") {
          isPayment = true;
        }
      }
    } else {
      if (value.paymentStatus!.toLowerCase() != "completed") {
        isPayment = true;
      } else {
        isPayment = false;
      }
    }
  }

  return isPayment;
}

double totalServicesCharges(BookingModel bookingModel) {
  double price = 0.0;
  for (var d in bookingModel.extraCharges!) {
    price = price + d.total!;
  }
  return price;
}

double totalServicesChargesAndTotalBooking(BookingModel bookingModel) {
  double price = 0.0;
  for (var d in bookingModel.extraCharges!) {
    price = price + d.total!;
  }

  if (bookingModel.paymentMethod!.toLowerCase() == "cash") {
    price = price + bookingModel.total!;
  } else {
    if (bookingModel.paymentStatus!.toLowerCase() != "completed") {
      price = price + bookingModel.total!;
    }
  }

  return price;
}

/// Capitalize given String
String capitalizeFirstLetter(String? val) {
  if (val == null || val.isEmpty) {
    return validate(value: val);
  }
  return val[0].toString().toUpperCase() + val.substring(1);
}

// Check null string, return given value if null
String validate({String? value}) {
  if (isEmptyOrNull(value)) {
    return value!;
  } else {
    return value!;
  }
}

/// Returns true if given String is null or isEmpty
bool isEmptyOrNull(val) =>
    val == null ||
    (val != null && val!.isEmpty) ||
    (val != null && val! == 'null');

//get address data
String getAddress(context, addressId) {
  String address = "";
  final loc = Provider.of<LocationProvider>(context, listen: false);

  int index = loc.addressList
      .indexWhere((element) => element.id.toString() == addressId.toString());
  print("loc.addressList :${index}");
  if (index >= 0) {
    address =
        "${loc.addressList[index].address}-${loc.addressList[index].area ?? loc.addressList[index].state!.name}";
  }
  return address;
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 1,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
  googlePlayIdentifier: 'com.webiots.fixituserapi',
);

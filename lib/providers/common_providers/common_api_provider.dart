import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:leadvala/config.dart';

import '../../models/app_setting_model.dart';

class CommonApiProvider extends ChangeNotifier {
  //self api
  var dio = Dio();
  UserModel? _userModel; // Store user data here

  UserModel? get userModel => _userModel; // Getter for UI access

  Future<void> selfApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken") ?? "NO_TOKEN";

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      print('🚀 Calling self API...');

      var response = await dio.get(
        api.self,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print('✅ API Response: ${json.encode(response.data)}');

        if (!response.data.containsKey("user") ||
            response.data["user"] == null) {
          print("❌ ERROR: 'user' key is missing or null in API response!");
          return;
        }

        // ✅ Set the userModel and call notifyListeners()
        _userModel = UserModel.fromJson(response.data["user"]);
        print('🔹 Parsed UserModel: ${json.encode(_userModel!.toJson())}');
        print('🟢 Wallet Balance: ${_userModel!.wallet?.balance}');

        await prefs.setString(session.user, json.encode(_userModel!.toJson()));

        // ✅ Ensure UI updates with new data
        notifyListeners();
      } else {
        print('⚠️ API Error: ${response.statusMessage}');
      }
    } catch (e) {
      print('❌ API Call Failed: $e');
    }
    notifyListeners();
  }
//  tempory stope
  // selfApi(context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("accessToken") ?? "NO_TOKEN";

  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   try {
  //     print('🚀 Calling self API...');

  //     var response = await dio.get(
  //       api.self,
  //       options: Options(headers: headers),
  //     );

  //     if (response.statusCode == 200) {
  //       print('✅ API Response:???//hello ${json.encode(response.data)}');

  //       // ✅ Ensure 'user' key exists
  //       if (!response.data.containsKey("user") ||
  //           response.data["user"] == null) {
  //         print("❌ ERROR: 'user' key is missing or null in API response!");
  //         return;
  //       }
  //       notifyListeners();
  //       // ✅ Correct Parsing
  //       UserModel userModel = UserModel.fromJson(response.data["user"]);
  //       print('🔹 Parsed UserModel: ${json.encode(userModel.toJson())}');
  //       print('showing data of this wallet??${userModel.wallet!.balance}');
  //       // ✅ Save UserModel to SharedPreferences
  //       await prefs.setString(session.user, json.encode(userModel.toJson()));

  //       // ✅ Verify Data in SharedPreferences
  //       String? storedData = prefs.getString(session.user);
  //       print("🔵 Stored User Data in SharedPreferences: $storedData");

  //       notifyListeners();
  //       return;
  //     } else {
  //       print('⚠️ API Error: ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     print('❌ API Call Failed: $e');
  //   }
  //   notifyListeners();
  // }

  // selfApi(context) async {
  //   var body = {};
  //   print('self apis---${body}');
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   try {
  //     // print('try to call');
  //     await apiServices.getApi(api.self, [], isToken: true).then((value) {
  //       print('call to apis proccess :-- ${value.isSuccess}');
  //       print(' Response Data: ${value.data}');
  //       print(' UserModel Updated: ${json.encode(userModel)}');
  //       log("DDD");

  //       print('value');
  //       log("DDD");
  //       log("value.data: ${value.data}");
  //       userModel = UserModel.fromJson(value.data);
  //       pref.setString(
  //           session.user, json.encode(UserModel.fromJson(value.data)));

  //       notifyListeners();
  //       log("DDD1");
  //     });
  //   } catch (e) {
  //     log("SELF :$e");
  //     print('self data call api error ${e}');
  //     notifyListeners();
  //   }
  // }

  // selfApi(context) async {
  //   var body = {};
  //   print('self apis---${body}');
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   try {
  //     // print('try to call');
  //     await apiServices.getApi(api.self, [], isToken: true).then((value) {
  //       print('call to apis proccess :-- ${value.isSuccess}');
  //       print(' Response Data: ${value.data}');
  //       print(' UserModel Updated: ${json.encode(userModel)}');
  //       log("DDD");

  //       print('value');
  //       log("DDD");
  //       log("value.data: ${value.data}");
  //       userModel = UserModel.fromJson(value.data);
  //       pref.setString(
  //           session.user, json.encode(UserModel.fromJson(value.data)));

  //       notifyListeners();
  //       log("DDD1");
  //     });
  //   } catch (e) {
  //     log("SELF :$e");
  //     print('self data call api error ${e}');
  //     notifyListeners();
  //   }
  // }

  Future<ProviderModel> getProviderById(id) async {
    ProviderModel? providerModel;
    try {
      await apiServices
          .getApi("${api.provider}/$id", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          providerModel = ProviderModel.fromJson(value.data);
          notifyListeners();
          return providerModel;
        }
      });
      return providerModel!;
    } catch (e) {
      log("ERRROEEE getProviderById common: $e");
      notifyListeners();
    }

    return providerModel!;
  }

  getData(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("pref :$pref");
    dynamic userData = pref.getString(session.user);
    if (userData != null) {
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      await commonApi.selfApi(context);
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);

      await locationCtrl.getUserCurrentLocation(context);
      //await locationCtrl.getLocationList();
      final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
      final favCtrl =
          Provider.of<FavouriteListProvider>(context, listen: false);
      favCtrl.getFavourite();
      dashCtrl.getBookingHistory(context);

      dashCtrl.getServicePackage();
      final cartCtrl = Provider.of<CartProvider>(context, listen: false);
      cartCtrl.onReady(context);
      final notifyCtrl =
          Provider.of<NotificationProvider>(context, listen: false);
      notifyCtrl.getNotificationList(context);
      dashCtrl.getBookingStatus();
    }
  }

  Future<bool> checkForAuthenticate() async {
    bool isAuth = false;
    try {
      await apiServices.getApi(api.address, [], isToken: true).then((value) {
        log("sdhfjsdkhf :");
        if (value.isSuccess!) {
          isAuth = true;
          notifyListeners();
          return isAuth;
        } else {
          if (value.message.toLowerCase() == "unauthenticated.") {
            isAuth = false;
            notifyListeners();
            return isAuth;
          } else {
            isAuth = false;
            notifyListeners();
            return isAuth;
          }
        }
      });
    } catch (e) {
      log("EEE homeStatisticApi :$e");
      return isAuth;
    }
    log("isAuth:$isAuth");
    return isAuth;
  }

  Future<void> getPaymentMethodList(BuildContext context) async {
    print('🚀 Fetching Payment Methods...');

    try {
      var response = await apiServices.getApi(api.paymentMethod, []);

      if (response.isSuccess! && response.data != null) {
        // ✅ Ensure response.data is a list before mapping
        if (response.data is List) {
          paymentMethods = (response.data as List)
              .map((d) => PaymentMethods.fromJson(d))
              .toList();
        } else {
          print("⚠️ API response is not a List. Received: ${response.data}");
        }
      } else {
        print("❌ Failed to load payment methods: ${response.message}");
        paymentMethods = []; // ✅ Avoid null assignment
      }
    } catch (e) {
      print("❌ ERROR: $e");
      paymentMethods = []; // ✅ Ensure list is not null
    }

    notifyListeners(); // 🔥 UI updates
  }

  // getPaymentMethodList(context) async {
  //   print('call to get paymentmethod show ');
  //   try {
  //     await apiServices.getApi(api.paymentMethod, []).then((value) {
  //       print('get payment method list ${value.data}');
  //       log("VALUE :${value.data}");
  //       if (value.isSuccess!) {
  //         paymentMethods = [];
  //         for (var d in value.data) {
  //           paymentMethods.add(PaymentMethods.fromJson(d));
  //         }
  //         notifyListeners();
  //       }

  //       notifyListeners();
  //     });
  //   } catch (e) {
  //     print('showing of error message $e');
  //     log("EEEE getPaymentMethodList:$e");
  //     notifyListeners();
  //   }
  // }

  getCategoryById(context, id) async {
    log('getcategorybyId----------');
    CategoryModel? categoryModel;
    try {
      log('try');
      await apiServices
          .getApi("${api.category}/$id", [], isData: true, isMessage: false)
          .then((value) {
        log("CCCCC :${value.data}");
        if (value.isSuccess!) {
          log('if logs');
          categoryModel = CategoryModel.fromJson(value.data[0]);
          notifyListeners();

          route.pushNamed(context, routeName.categoriesDetailsScreen,
              arg: categoryModel);
        }
      });
    } catch (e) {
      log("ERRROEEE getCategoryById : $e");
      notifyListeners();
    }
  }
}

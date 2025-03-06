import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:leadvala/common_tap.dart';
import 'package:leadvala/models/booking_response_model.dart' as booking_model;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;

class DashboardProvider with ChangeNotifier {
  var dio = Dio();
  List<BannerModel> bannerList = [];
  List<OfferModel> offerList = [];
  List<ProviderModel> highestRateList = [];
  List<CurrencyModel> currencyList = [];
  List<CouponModel> couponList = [];
  List<CategoryModel> categoryList = [];
  List<ServicePackageModel> servicePackagesList = [];
  List<ServicePackageModel> firstThreeServiceList = [];
  List<Services> featuredServiceList = [];
  static const pageSize = 1;
  SharedPreferences? pref;

  List<Services> firstTwoFeaturedServiceList = [];
  List<ProviderModel> firstTwoHighRateList = [];
  List<BlogModel> blogList = [];
  List<BlogModel> firstTwoBlogList = [];
  List<ProviderModel> providerList = [];
  ProviderModel? provider;

  List<BookingStatusModel> bookingStatusList = [];
  List service = appArray.servicesList.getRange(1, 3).toList();
  bool expanded = false;
  int selectIndex = 0, backCounter = 0;
  int? topSelected;
  bool isTap = false, isSearchData = false;

  final List<Widget> pages = [
    const HomeScreen(),
    const BookingScreen(),
    const OfferScreen(),
    const ProfileScreen()
  ];

  onTap(index, context) async {
    selectIndex = index;
    expanded = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    expanded = false;
    if (selectIndex != 0) {
      final homeCtrl = Provider.of<HomeScreenProvider>(context, listen: false);
      homeCtrl.animationController!.stop();
      homeCtrl.notifyListeners();
    } else {
      if (selectIndex == 3) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool isGuest = preferences.getBool(session.isContinueAsGuest) ?? false;
        if (isGuest == false) {
          final homeCtrl =
              Provider.of<HomeScreenProvider>(context, listen: false);
          homeCtrl.animationController!.reset();
          homeCtrl.notifyListeners();
        } else {
          route.pushAndRemoveUntil(context);
        }
      } else {
        final homeCtrl =
            Provider.of<HomeScreenProvider>(context, listen: false);
        homeCtrl.animationController!.reset();
        homeCtrl.notifyListeners();
      }
    }
    if (selectIndex != 1) {
      final booking = Provider.of<BookingProvider>(context, listen: false);
      if (booking.animationController != null) {
        if (booking.animationController != null) {
          booking.animationController!.stop();
          booking.notifyListeners();
        }
      }
      final data = Provider.of<DashboardProvider>(context, listen: false);
      data.getBookingHistory(context);
      final book = Provider.of<BookingProvider>(context, listen: false);

      book.clearTap(context, isBack: false);
    } else if (selectIndex == 1) {
      final booking = Provider.of<BookingProvider>(context, listen: false);
      booking.animationController!.reset();
      booking.notifyListeners();
    }
    notifyListeners();
  }

  //on back
  onBack(context) async {
    if (selectIndex != 0) {
      selectIndex = 0;
      notifyListeners();
      Fluttertoast.showToast(msg: language(context, appFonts.pressBackAgain));
    } else {
      if (backCounter == 0) {
        Fluttertoast.showToast(msg: language(context, appFonts.pressBackAgain));
        backCounter++;
        notifyListeners();
      } else {
        backCounter = 0;
        notifyListeners();
        SystemNavigator.pop();
      }
    }
  }

  onRefresh(context) async {
    final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
    await locationCtrl.getZoneId();
    getBanner();
    getOffer();
    getCoupons();

    getCategory();
    getServicePackage();
    getProvider();

    getFeaturedPackage(1);
    getHighestRate();
    getBlog();
  }

  getBanner() async {
    try {
      print("🚀 Calling API: ${api.banner}");

      await apiServices.getApi(api.banner, []).then((value) {
        print('✅ API Response:1 ${json.encode(value.data)}');
        print('✅ API Response:2 ${json.encode(value.data)}');

        if (value.isSuccess!) {
          print("🎯 Success: API returned data!");

          bannerList = [];
          for (var data in value.data) {
            bannerList.add(BannerModel.fromJson(data));
          }

          notifyListeners();
          print("✅ Banners Loaded: ${bannerList.length}");
        } else {
          print("⚠️ API Response Error: ${value.message}");
        }
        loadDashboardDataInBackground();
        // getCategory();
        // getServicePackage();
        // getOffer();
        // getCoupons();
        // getProvider();
        // getFeaturedPackage(1);
        // getHighestRate();
        // getBlog();

        log("BANNER COUNT: ${bannerList.length}");
      });
    } catch (e) {
      log("❌ ERROR in getBanner(): $e");
      notifyListeners();
    }
  }

  loadDashboardDataInBackground() {
    getCategory().then((_) => print("✅ Category loaded"));
    getCoupons().then((_) => print("✅ Coupons loaded"));
    // getBookingHistoryprovider().then((_) => print('hello this function run'));
    getServicePackage().then((_) => print("✅ Service packages loaded"));
    getOffer().then((_) => print("✅ Offers loaded"));
    getProvider().then((_) => print("✅ Providers loaded"));
    getFeaturedPackage(1).then((_) => print("✅ Featured package loaded"));
    getHighestRate().then((_) => print("✅ Highest rated services loaded"));
    getBlog().then((_) => print("✅ Blogs loaded"));
  }

  //offer list
  getOffer() async {
    print('get offeer');
    try {
      await apiServices
          .getApi("${api.banner}?banner_type=true", []).then((value) {
        print('banner daadd${value.data}');
        if (value.isSuccess!) {
          offerList = [];
          notifyListeners();
          for (var data in value.data) {
            offerList.add(OfferModel.fromJson(data));
            notifyListeners();
          }
        }
        notifyListeners();
      });
    } catch (e) {
      print('showing :: $e');
      log("EEEE getOffer : $e");
      notifyListeners();
    }
  }

  //highest rate provider list
  getHighestRate() async {
    try {
      await apiServices
          .getApi(api.highestRating, [], isData: true, isMessage: true)
          .then((value) {
        if (value.isSuccess!) {
          highestRateList = [];
          firstTwoHighRateList = [];
          debugPrint("HIGHH :${value.data}");
          for (var data in value.data) {
            highestRateList.add(ProviderModel.fromJson(data));
            debugPrint("highestRateList :$data");
            notifyListeners();
          }
          if (highestRateList.length >= 3) {
            firstTwoHighRateList = highestRateList.getRange(0, 3).toList();
          }

          debugPrint("firstTwoHighRateList :${firstTwoHighRateList.length}");
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint("getHighestRate ::$e");
      notifyListeners();
    }
  }

//currency list
  getCurrency() async {
    try {
      await apiServices.getApi(api.currency, []).then((value) {
        if (value.isSuccess!) {
          currencyList = [];
          debugPrint("fbhgfvhg:${value.data}");
          for (var data in value.data) {
            currencyList.add(CurrencyModel.fromJson(data));
            notifyListeners();
          }
        }
      });
    } catch (e) {
      debugPrint("getCurrency ::$e}");

      notifyListeners();
    }
  }

//coupons list
  getCoupons() async {
    print('🚀 Fetching coupons...');
    var response = await dio.request(
      api.coupon,
      options: Options(method: 'GET'),
    );

    if (response.statusCode == 200) {
      print('✅ Coupons API Response: ${json.encode(response.data)}');

      couponList.clear(); // Clear old list before adding new items
      List<dynamic> dataList = response.data["data"]; // Fix API structure issue

      for (var data in dataList) {
        couponList.add(CouponModel.fromJson(data));
      }

      print('✅ Coupons Loaded: ${couponList.length}');
      notifyListeners(); // 🔥 Ensure UI updates
    } else {
      print('⚠️ Failed to load coupons: ${response.statusMessage}');
    }
  }

  // getCoupons() async {
  //   print('showing coupons');
  //   var response = await dio.request(
  //     api.coupon,
  //     options: Options(
  //       method: 'GET',
  //     ),
  //   );

  //   if (response.statusCode == 200) {
  //     print('addddddd${response.statusCode}');
  //     couponList = [];
  //     for (var data in response.data) {
  //       couponList.add(CouponModel.fromJson(data));
  //       notifyListeners();
  //     }
  //     print('all done ok value ');
  //     print(json.encode(response.data));
  //   } else {
  //     print('all detail about else');
  //     notifyListeners();
  //     print(response.statusMessage);
  //   }
  // }

  //category list
  getCategory({search}) async {
    // notifyListeners();
    debugPrint("zoneIds zoneIds:$zoneIds");
    print('showing loading data');
    try {
      String apiUrl = "${api.category}?zone_ids=$zoneIds";
      print('api url data1$apiUrl');
      if (zoneIds.isNotEmpty) {
        if (search != null) {
          apiUrl = "${api.category}?search=$search&zone_ids=$zoneIds";
          print('api url data2$apiUrl');
        } else {
          apiUrl = "${api.category}?zone_ids=$zoneIds";
          print('api url data3$apiUrl');
        }
      } else {
        if (search != null) {
          apiUrl = "${api.category}?search=$search";
          print('api url data4$apiUrl');
        } else {
          apiUrl = api.category;
          print('api url data4$apiUrl');
        }
      }
      print('last of this function data$apiUrl');
      await apiServices.getApi(apiUrl, []).then((value) {
        print('showing ?? data${value.data}');
        if (value.isSuccess!) {
          List category = value.data;
          categoryList = [];
          for (var data in category.reversed.toList()) {
            if (!categoryList.contains(CategoryModel.fromJson(data))) {
              categoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      notifyListeners();
      log("EEEE getCategory : $e");
    }
  }

  //service package list
  getServicePackage() async {
    debugPrint("SERR :$zoneIds");
    try {
      String apiUrl = api.servicePackages;
      if (zoneIds.isNotEmpty) {
        apiUrl = "${api.servicePackages}?zone_ids=$zoneIds";
      } else {
        apiUrl = api.servicePackages;
      }
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          List service = value.data;
          servicePackagesList = [];
          for (var data in service.reversed.toList()) {
            servicePackagesList.add(ServicePackageModel.fromJson(data));
            notifyListeners();
          }
          if (servicePackagesList.length >= 3) {
            firstThreeServiceList = servicePackagesList.getRange(0, 3).toList();
          }
          notifyListeners();

          debugPrint("servicePackagesList LEN: ${servicePackagesList.length}");
        }
      });
    } catch (e) {
      notifyListeners();
      log("EEEE getServicePackage s: $e");
    }
  }

  //featured package list
  getFeaturedPackage(page) async {
    try {
      await apiServices.getApi(api.featuredServices, []).then((value) {
        if (value.isSuccess!) {
          featuredServiceList = [];
          firstTwoFeaturedServiceList = [];
          List service = value.data;
          for (var data in service.reversed.toList()) {
            if (!featuredServiceList.contains(Services.fromJson(data))) {
              featuredServiceList.add(Services.fromJson(data));
            }
            notifyListeners();
          }
          if (featuredServiceList.length >= 2) {
            firstTwoFeaturedServiceList =
                featuredServiceList.getRange(0, 2).toList();
          }
          notifyListeners();
        }
        log("FA :${featuredServiceList.length}");
      });
    } catch (e) {
      notifyListeners();
      log("EEEE getFeaturedPackage : $e");
    }
  }

  //blog list
  getBlog() async {
    try {
      await apiServices.getApi(api.blog, []).then((value) {
        if (value.isSuccess!) {
          blogList = [];
          List service = value.data['data'];
          for (var data in service.reversed.toList()) {
            blogList.add(BlogModel.fromJson(data));
            notifyListeners();
          }
          if (blogList.length >= 6) {
            firstTwoBlogList = blogList.getRange(0, 6).toList();
          }
          notifyListeners();
        }
        debugPrint("firstTwoBlogList :${firstTwoBlogList.length}");
      });
    } catch (e) {
      log("EEEE getBlog : $e");
      notifyListeners();
    }
  }

  //provider list
  getProvider() async {
    try {
      await apiServices.getApi(api.provider, []).then((value) {
        if (value.isSuccess! && value.data != null) {
          List<dynamic> providerData = value.data; // ✅ Ensure it's a list

          print('📌 Raw Provider Data: $providerData');

          if (providerData.isNotEmpty) {
            providerList.clear(); // ✅ Clear list before adding new items

            for (var data in providerData.reversed) {
              try {
                print('🔄 Processing Provider Data: $data');

                ProviderModel providerModel = ProviderModel.fromJson(data);
                providerList.add(providerModel);

                print(
                    '✅ Added Provider: ${providerModel.id} - ${providerModel.name}');
                print('✅ Added Provider: ${providerList.first.id} ');
              } catch (e) {
                print('❌ Error Parsing Provider Data: $e');
              }
            }

            notifyListeners();
            print("✅ Final providerList Size: ${providerList.length}");
          } else {
            print("⚠️ Provider list is empty.");
          }
        } else {
          print("❌ API Call Failed or Data is Null");
        }
      });
    } catch (e) {
      print("❌ Exception in getProvider(): $e");
      notifyListeners();
    }
  }

  // getProvider() async {
  //   try {
  //     await apiServices.getApi(api.provider, []).then((value) {
  //       if (value.isSuccess!) {
  //         List provider = value.data;
  //         print('check to list of data???$provider');
  //         providerList = [];
  //         for (var data in provider.reversed.toList()) {
  //           print('how dos check it on');
  //           providerList.add(ProviderModel.fromJson(data));
  //           print('check to list ffff${providerList.first.id}');
  //           notifyListeners();
  //         }

  //         notifyListeners();
  //         debugPrint("providerList ::${providerList.length}");
  //         print("providerList ::${providerList.length}");
  //       }
  //     });
  //   } catch (e) {
  //     notifyListeners();
  //   }
  // }

  //booking history list
  // getBookingHistoryprovider() async {
  //   providerList = [];
  //   try {
  //     print('Fetching provider list...');
  //     await apiServices.getApi(api.provider, []).then((value) {
  //       print('Fetching provider list...${value.data}');

  //       if (value.isSuccess!) {
  //         print('Data received: ${value.data.length} items');
  //         print('Data received:1111111 ${value.data.length} items');
  //         List provider = value.data;

  //         for (var data in provider.reversed.toList()) {
  //           try {
  //             providerList.add(ProviderModel.fromJson(data));
  //             print('Data received:1111111 ${providerList.length} items');
  //           } catch (e) {
  //             print('❌ Skipping invalid provider data: $e');
  //           }
  //         }

  //         notifyListeners();
  //         debugPrint("Final providerList size: ${providerList.length}");
  //       }
  //     });
  //   } catch (e) {
  //     print('❌ Error fetching providers: $e');
  //   }
  // }

  // getBookingHistoryList() async {
  //   providerList = [];
  //   try {
  //     print('booking history list');
  //     await apiServices.getApi(api.provider, []).then((value) {
  //       print('showing data of??? ${value.data}');
  //       if (value.isSuccess!) {
  //         print('check of this data??');
  //         List provider = value.data;
  //         print('no of3333$provider');
  //         for (var data in provider.reversed.toList()) {
  //           providerList.add(ProviderModel.fromJson(data));
  //           print('check it of list data${provider.length}');
  //           notifyListeners();
  //         }

  //         notifyListeners();
  //         debugPrint("providerList ::${providerList.length}");
  //         print('providerList ::${providerList.length}');
  //       }
  //     });
  //   } catch (e) {
  //     print('catch of data on this $e');
  //     notifyListeners();
  //   }
  // }

  onRemoveService(context, index) async {
    if (firstTwoFeaturedServiceList.isEmpty) {
      if ((featuredServiceList[index].selectedRequiredServiceMan!) == 1) {
        isAlert = false;
        notifyListeners();
        route.pop(context);
      } else {
        if ((featuredServiceList[index].requiredServicemen!) ==
            (featuredServiceList[index].selectedRequiredServiceMan!)) {
          isAlert = true;
          notifyListeners();
          await Future.delayed(DurationClass.s3);
          isAlert = false;
          notifyListeners();
        } else {
          isAlert = false;
          notifyListeners();
          featuredServiceList[index].selectedRequiredServiceMan =
              ((featuredServiceList[index].selectedRequiredServiceMan!) - 1);
        }
      }
    } else {
      if ((firstTwoFeaturedServiceList[index].selectedRequiredServiceMan!) ==
          1) {
        isAlert = false;
        notifyListeners();
        route.pop(context);
      } else {
        debugPrint("djghdfkjg");
        if ((featuredServiceList[index].requiredServicemen!) ==
            (featuredServiceList[index].selectedRequiredServiceMan!)) {
          isAlert = true;
          notifyListeners();
          await Future.delayed(DurationClass.s3);
          isAlert = false;
          notifyListeners();
        } else {
          isAlert = false;
          notifyListeners();
          featuredServiceList[index].selectedRequiredServiceMan =
              ((featuredServiceList[index].selectedRequiredServiceMan!) - 1);
        }
      }
    }
    notifyListeners();
  }

  onAdd(index) {
    print('onAdd');

    isAlert = false;
    notifyListeners();
    int count = (featuredServiceList[index].selectedRequiredServiceMan!);
    count++;
    featuredServiceList[index].selectedRequiredServiceMan = count;

    notifyListeners();
  }

  onAddTap(context, Services? service, index, inCart) {
    print('on tap tp addtap');
    if (inCart) {
      route.pushNamed(context, routeName.cartScreen);
    } else {
      final providerDetail =
          Provider.of<ProviderDetailsProvider>(context, listen: false);
      providerDetail.selectProviderIndex = 0;
      providerDetail.notifyListeners();
      onBook(context, service!,
          provider: service.user,
          addTap: () => onAdd(index),
          minusTap: () => onRemoveService(context, index)).then((e) {
        featuredServiceList[index].selectedRequiredServiceMan =
            featuredServiceList[index].requiredServicemen;
        notifyListeners();
      });
    }
  }

  //booking status list
  getBookingStatus() async {
    try {
      await apiServices
          .getApi(api.bookingStatus, [], isToken: true)
          .then((value) {
        debugPrint("STATYS L ${value.data}");
        if (value.isSuccess!) {
          for (var data in value.data) {
            bookingStatusList.add(BookingStatusModel.fromJson(data));
            notifyListeners();
          }
        }
      });

      notifyListeners();

      debugPrint("STATYS Lss ${bookingStatusList.length}");
      int cancelIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "cancel" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "cancelled");
      if (cancelIndex >= 0) {
        debugPrint("CANCEl :${bookingStatusList[cancelIndex].slug}");
        appFonts.cancel = bookingStatusList[cancelIndex].slug!;
      }
      int acceptedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "accepted" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "accept");
      if (acceptedIndex >= 0) {
        debugPrint("ACCEPTEF :${bookingStatusList[acceptedIndex].slug}");
        appFonts.accepted = bookingStatusList[acceptedIndex].slug!;
      }

      int assignedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "assign" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "assigned");
      if (assignedIndex >= 0) {
        debugPrint("ASSIGNED :${bookingStatusList[assignedIndex].slug}");
        appFonts.assigned = bookingStatusList[assignedIndex].slug!;
      }

      int onTheWayIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "ontheway");
      if (onTheWayIndex >= 0) {
        debugPrint("ON THE WAY :${bookingStatusList[onTheWayIndex].slug}");
        appFonts.ontheway = bookingStatusList[onTheWayIndex].slug!;
      }

      int onGoingIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "ongoing");
      if (onGoingIndex >= 0) {
        debugPrint("ONGOING :${bookingStatusList[onGoingIndex].slug}");
        appFonts.onGoing = bookingStatusList[onGoingIndex].slug!;
      }

      int onHoldIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "onhold");
      if (onHoldIndex >= 0) {
        debugPrint("onHOLD :${bookingStatusList[onHoldIndex].slug}");
        appFonts.onHold = bookingStatusList[onHoldIndex].slug!;
      }

      int restartIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "restart");
      if (restartIndex >= 0) {
        debugPrint("RESTART :${bookingStatusList[restartIndex].slug}");
        appFonts.restart = bookingStatusList[restartIndex].slug!;
      }

      int startAgainIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "startagain");
      if (startAgainIndex >= 0) {
        debugPrint("START AGAIN :${bookingStatusList[startAgainIndex].slug}");
        appFonts.startAgain = bookingStatusList[startAgainIndex].slug!;
      }

      int completedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "completed" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "complete");
      if (completedIndex >= 0) {
        debugPrint("COMPLETED:${bookingStatusList[completedIndex].slug}");
        appFonts.completed = bookingStatusList[completedIndex].slug!;
      }

      notifyListeners();

      debugPrint("APPP ;${appFonts.ontheway}");
    } catch (e) {
      log("EEEE getBookingStatus: $e");
      notifyListeners();
    }
  }

  //booking history list
  getBookingHistory(BuildContext context,
      {String? search, int pageKey = 1}) async {
    print('📌 Fetching booking history...'); // Start log
    final booking = Provider.of<BookingProvider>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('🛠️ SharedPreferences loaded.');

    try {
      String? token = prefs.getString("accessToken") ?? "NO_TOKEN";
      print('🔑 Access Token: $token'); // Log token (ensure it's valid)

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('📝 Headers: $headers');

      print('🔗 Making API request...');
      var response = await dio.request(
        api.booking,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      print('🔗 API Response Received'); // Log API response success
      print('📜 Full Response: ${response.data}');

      if (response.statusCode == 200) {
        print("✅ Status Code: 200 (Success)");

        if (response.data == null) {
          print("⚠️ API returned null data.");
          booking.bookingList = [];
        } else {
          print("📌 Processing API response data...");

          try {
            var parsedData =
                booking_model.BookingResponseModel.fromJson(response.data);
            print("✅ JSON Parsing Successful");

            if (parsedData.data != null && parsedData.data!.isNotEmpty) {
              print('📦 Parsed Data Length: ${parsedData.data!.length}');
              booking.bookingList = parsedData.data!;
              print('✅ Booking list updated successfully.');
            } else {
              print("⚠️ No booking data found in API response.");
              booking.bookingList = [];
            }
          } catch (jsonError) {
            print("❌ JSON Parsing Error: $jsonError");
            booking.bookingList = [];
          }
        }
      } else {
        print(
            "❌ API Error: ${response.statusCode}, Message: ${response.statusMessage}");
        booking.bookingList = [];
      }

      // Handle empty list
      if (booking.bookingList.isEmpty) {
        print("⚠️ Booking list is empty. Clearing chat.");
        clearChat(context);
      }

      booking.notifyListeners();
      print("✅ Final Booking List Count: ${booking.bookingList.length}");
    } catch (e, stackTrace) {
      print("❌ Exception in getBookingHistory: $e");
      print("🕵️‍♂️ Stack Trace: $stackTrace");
      booking.bookingList = [];
      booking.notifyListeners();
    }
  }

  // getBookingHistory(context, {search, pageKey = 1}) async {
  //   print('booking history');
  //   final booking = Provider.of<BookingProvider>(context, listen: false);
  //   dynamic data;

  //   debugPrint("BD:: $data");
  //   try {
  //     String? token = pref?.getString(session.accessToken);
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };
  //     var response = await dio.request(
  //       'https://fix-it.swarnkarsamajudaipur.com/api/booking',
  //       options: Options(
  //         method: 'GET',
  //         headers: headers,
  //       ),
  //     );
  //     count++;
  //     print('login to api call booking::>>> ${response}');
  //     if (response.statusCode == 200) {
  //       booking.bookingList = [];
  //       final responseData = jsonDecode(response.data);
  //       print("before for loop $responseData");
  //       print("hello data 1 :${data}");
  //       booking.bookingList = [];
  //       booking.bookingList =
  //           booking_model.BookingResponseModel.fromJson(responseData).data ??
  //               [];
  //       if (booking.bookingList.isEmpty) {
  //         if (search != null) {
  //           isSearchData = true;
  //           booking.searchText.text = "";
  //           booking.notifyListeners();
  //         } else {
  //           isSearchData = false;
  //         }
  //       } else {
  //         isSearchData = false;
  //       }
  //       booking.notifyListeners();
  //     } else {
  //       booking.bookingList = [];
  //       booking.notifyListeners();
  //     }
  //     if (booking.bookingList.isEmpty) {
  //       clearChat(context);
  //     }
  //     booking.notifyListeners();
  //     log("booking.bookingList :${booking.bookingList.length}");
  //   } catch (e) {
  //     debugPrint("E getBookingHistory ::$e");
  //     notifyListeners();
  //   }
  // }

  clearChat(context) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userModel!.id.toString())
          .collection(collectionName.chats)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.asMap().entries.forEach((element) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(userModel!.id.toString())
                .collection(collectionName.chatWith)
                .doc(userModel!.id.toString() ==
                        element.value['senderId'].toString()
                    ? element.value['receiverId'].toString()
                    : element.value['senderId'].toString())
                .collection(collectionName.booking)
                .doc(element.value['bookingId'].toString())
                .collection(collectionName.chat)
                .get()
                .then((v) {
              for (var d in v.docs) {
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(userModel!.id.toString())
                    .collection(collectionName.chatWith)
                    .doc(userModel!.id.toString() ==
                            element.value['senderId'].toString()
                        ? element.value['receiverId'].toString()
                        : element.value['senderId'].toString())
                    .collection(collectionName.booking)
                    .doc(element.value['bookingId'].toString())
                    .collection(collectionName.chat)
                    .doc(d.id)
                    .delete();
              }
            }).then((a) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(userModel!.id.toString())
                  .collection(collectionName.chats)
                  .doc(value.docs[0].id)
                  .delete();
            }).then((value) {
              final chat =
                  Provider.of<ChatHistoryProvider>(context, listen: false);
              chat.onReady(context);
            });
          });
        }

        notifyListeners();
      });
    } catch (e) {
      notifyListeners();
    }
  }

  onFeatured(context, Services? services, id, {inCart}) async {
    if (inCart) {
      route.pushNamed(context, routeName.cartScreen);
    } else {
      /* final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      ProviderModel provider =
          await commonApi.getProviderById(services!.userId);*/
      final providerDetail =
          Provider.of<ProviderDetailsProvider>(context, listen: false);
      providerDetail.selectProviderIndex = 0;
      providerDetail.notifyListeners();
      onBook(context, services!,
              // provider: provider,
              addTap: () => onAdd(id),
              minusTap: () => onRemoveService(context, id))!
          .then((e) {
        featuredServiceList[id].selectedRequiredServiceMan =
            featuredServiceList[id].requiredServicemen;
        notifyListeners();
      });
    }
  }

  onBannerTap(context, id) {
    print('onbannerTap');
    // log('onbannerTap---------$id');
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    commonApi.getCategoryById(context, id);
  }

  cartTap(context) async {
    print('cartscreen value show ');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    getCoupons();
    bool isGuest = preferences.getBool(session.isContinueAsGuest) ?? false;
    print('showing cart tape ${isGuest}');

    if (isGuest == false) {
      final cartCtrl = Provider.of<CartProvider>(context, listen: false);
      debugPrint("dg :");
      cartCtrl.checkout(context);
      /* cartCtrl.cartList = [];
                        cartCtrl.notifyListeners();*/
      route.pushNamed(context, routeName.cartScreen);
    } else {
      route.pushAndRemoveUntil(context);
    }
  }

  void loadMockData() {
    bannerList = [
      BannerModel(
          id: 1,
          type: "type",
          relatedId: "relatedId",
          status: 1,
          createdAt: "createdAt",
          updatedAt: "updatedAt",
          media: [
            Media(id: 1, createdAt: "createdAt", updatedAt: "updatedAt")
          ]),
    ];
    offerList = [
      OfferModel(
          id: 1,
          title: "title",
          status: 1,
          createdAt: "createdAt",
          updatedAt: "updatedAt"),
      OfferModel(
          id: 1,
          title: "title",
          status: 1,
          createdAt: "createdAt",
          updatedAt: "updatedAt")
    ];
    highestRateList = [
      ProviderModel(
          id: 1,
          name: "name",
          email: "email",
          status: 1,
          createdAt: "createdAt",
          updatedAt: "updatedAt",
          media: [
            Media(id: 1, createdAt: "createdAt", updatedAt: "updatedAt")
          ]),
    ];

    notifyListeners();
  }
}






  //banner list
  // getBanner() async {
  //   try {
  //     await apiServices.getApi(api.banner, []).then((value) {
  //       print('banner data????${value.data}');
  //       if (value.isSuccess!) {
  //         bannerList = [];
  //         for (var data in value.data) {
  //           bannerList.add(BannerModel.fromJson(data));
  //           notifyListeners();
  //         }
  //       }
  //       getCategory();
  //       getServicePackage();
  //       getOffer();
  //       getCoupons();

  //       getProvider();

  //       getFeaturedPackage(1);
  //       getHighestRate();
  //       getBlog();
  //       log("BANNER : ${bannerList.length}");
  //     });
  //   } catch (e) {
  //     log("EEEE getBanner : $e");
  //     notifyListeners();
  //   }
  // }




// old coupun list function 
// try {
    //   await apiServices.getApi(api.coupon, []).then((value) {
    //     print('${value.data}');
    //     if (value.isSuccess!) {
    //       debugPrint("COUPN :${value.data}");
    //       couponList = [];
    //       for (var data in value.data) {
    //         couponList.add(CouponModel.fromJson(data));
    //         notifyListeners();
    //       }
    //     }
    //   });
    // } catch (e) {
    //   print('get coupons ::${e}');
    //   debugPrint("EEEE getCoupons: $e");
    //   notifyListeners();
    // }





// booking 
    // if (booking.selectedCategory.isNotEmpty && booking.rangeStart != null && booking.statusIndex != null) {
    //   print("Hello");
    //   data = {
    //     "status": bookingStatusList[booking.statusIndex!].slug,
    //     "start_date": booking.rangeStart,
    //     "end_date": booking.rangeEnd,
    //     "category_ids": booking.selectedCategory,
    //     "search": search
    //   };
    // } else if (booking.selectedCategory.isNotEmpty && booking.rangeStart != null) {
    //   print("Hello1");
    //   data = {
    //     "start_date": booking.rangeStart,
    //     "end_date": booking.rangeEnd,
    //     "category_ids": booking.selectedCategory,
    //     "search": search
    //   };
    // } else if (booking.selectedCategory.isNotEmpty) {
    //   print("Hello2");
    //   data = {"category_ids": booking.selectedCategory};
    // } else if (booking.selectedCategory.isNotEmpty && booking.statusIndex != null) {
    //   print("Hello3");
    //   data = {
    //     "status": bookingStatusList[booking.statusIndex!].slug,
    //     "category_ids": booking.selectedCategory,
    //     "search": search
    //   };
    // } else if (booking.statusIndex != null) {
    //   print("Hello4");
    //   data = {"status": bookingStatusList[booking.statusIndex!].slug, "search": search};
    // } else if (booking.rangeStart != null && booking.statusIndex != null) {
    //   print("Hello5");
    //   data = {
    //     "status": bookingStatusList[booking.statusIndex!].slug,
    //     "start_date": booking.rangeStart,
    //     "end_date": booking.rangeEnd,
    //     "search": search
    //   };
    // } else if (booking.rangeStart != null) {
    //   print("Hello6");
    //   data = {"start_date": booking.rangeStart, "end_date": booking.rangeEnd, "search": search};
    // } else if (search != null) {
    //   print("Hello7");
    //   data = {"search": search};
    // }
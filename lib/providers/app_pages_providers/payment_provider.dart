import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:leadvala/widgets/alert_message_common.dart';
import 'package:flutter/cupertino.dart';

import '../../config.dart';
import '../../models/app_setting_model.dart';
import '../../screens/app_pages_screens/profile_detail_screen/layouts/selection_option_layout.dart';

class PaymentProvider with ChangeNotifier {
  int? selectIndex, bookingId = 0;
  UserModel? userModel;
  String? method;
  BookingModel? booking;
  SharedPreferences? preferences;
  CouponModel? data;

  dynamic checkoutBody;
  double wallet = 0.0;
  CheckoutModel? checkoutModel;
  String? itemId;
  List<PaymentMethods> paymentList = [];
  bool isWallet = false, isBottom = true, isRePayment = false;
  ScrollController scrollController = ScrollController();
  var dio = Dio();

  // get paymentMethods => null;
  getUserDetail(BuildContext context) async {
    print('🚀 Fetching User Details...');

    try {
      scrollController.addListener(listen);

      final common = Provider.of<CommonApiProvider>(context, listen: false);

      // ✅ Ensure `paymentMethods` is initialized
      paymentMethods ??= []; // Initialize if null

      await common.getPaymentMethodList(context);

      if (paymentMethods.isEmpty) {
        print("⚠️ No payment methods available. Fetching again...");
        await Future.delayed(Duration(seconds: 1)); // Small delay before retry
        await common.getPaymentMethodList(context);
      }

      for (var d in paymentMethods) {
        if (d.slug == "cash") {
          log("💵 Checking cash activation: ${appSettingModel?.activation?.cash}");
          if (appSettingModel?.activation?.cash == "1") {
            paymentList.add(d);
          }
        } else {
          paymentList.add(d);
        }
      }

      // ✅ Ensure SharedPreferences is not null
      preferences = await SharedPreferences.getInstance();
      var userData = preferences?.getString(session.user);

      if (userData != null) {
        userModel = UserModel.fromJson(json.decode(userData));

        // ✅ Fix Null Wallet Crash
        wallet = userModel?.wallet?.balance ?? 0.0;
        print('wallet showing data ?? ${userModel!}');
        print("👛 User Wallet Balance: ${wallet}");
      } else {
        print("⚠️ User data not found in SharedPreferences.");
      }

      dynamic data = ModalRoute.of(context)?.settings.arguments;
      bookingId = data?['bookingId'] ?? 0;
      print('??????????$bookingId');
      if (bookingId == 0) {
        print("🛒 Processing checkout...");
        checkoutBody = data?["checkoutBody"] ?? {};
        checkoutModel = data?["checkoutModel"];
      } else {
        getBookingDetailBy(context);
      }

      // ✅ Ensure a default payment method is selected
      if (paymentMethods.isNotEmpty) {
        method = paymentMethods.first.slug;
      } else {
        print("⚠️ No payment methods found. Retrying...");
        await common.getPaymentMethodList(context);
        method = paymentMethods.isNotEmpty ? paymentMethods.first.slug : "cash";
      }

      notifyListeners();
    } catch (e) {
      print("❌ ERROR in getUserDetail: $e");
      paymentMethods = []; // Ensure it’s never null in case of an error
    } finally {}
  }

  // getUserDetail(context) async {
  //   print('call12');
  //   print('call to get userdetail');
  //   scrollController.addListener(listen);
  //   final common = Provider.of<CommonApiProvider>(context, listen: false);
  //   await common.getPaymentMethodList(context);

  //   // for (var d in paymentMethods) {
  //   //   print('dddddddd$d');
  //   //   if (d.slug == "cash") {
  //   //     log("appSettingModel!.activation!.cash :${appSettingModel!.activation!.cash}");

  //   //     if (appSettingModel!.activation!.cash == "1") {
  //   //       paymentList.add(d);
  //   //     }
  //   //   } else {
  //   //     print('eeeee$paymentList');
  //   //     paymentList.add(d);
  //   //   }
  //   // }
  //   notifyListeners();
  //   preferences = await SharedPreferences.getInstance();
  //   var abc = preferences!.getString(session.user);
  //   print('showing data hellow?${abc}');
  //   Map user = json.decode(preferences!.getString(session.user)!);
  //   userModel =
  //       UserModel.fromJson(json.decode(preferences!.getString(session.user)!));
  //   print('user model :://${userModel!.wallet!.consumerId}');

  //   wallet = userModel!.wallet != null ? userModel!.wallet!.balance! : 0.0;
  //   print('user wallet :://${wallet}');

  //   dynamic data = ModalRoute.of(context)!.settings.arguments;
  //   print('user data :://${data}');

  //   bookingId = data['bookingId'] ?? 0;
  //   print('booking id :://${bookingId}');

  //   if (bookingId == 0) {
  //     print('bookingid');
  //     checkoutBody = data["checkoutBody"];
  //     checkoutModel = data["checkoutModel"];
  //     print('showing data ${checkoutBody}');
  //   } else {
  //     getBookingDetailBy(context);
  //   }
  //   if (paymentMethods.isNotEmpty) {
  //     method = paymentMethods[0].slug;
  //     print('method??$method');
  //   } else {
  //     final common = Provider.of<CommonApiProvider>(context, listen: false);
  //     await common.getPaymentMethodList(context);
  //     await Future.delayed(Durations.short3);
  //     // method = paymentMethods[0].slug;
  //     // print('method second load $method');
  //     // print('method second load $paymentMethods');
  //   }
  //   notifyListeners();
  // }

  void listen() {
    // print('call12');

    if (scrollController.position.pixels >= 100) {
      hide();
      log("scrollController.position.pixels${scrollController.position.pixels}");
      notifyListeners();
    } else {
      show();
      log("scrprollController.position.pixels${scrollController.position.pixels}");
      notifyListeners();
    }

    notifyListeners();
  }

  wlletpayment(BuildContext context) async {
    showLoading(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken") ?? "NO_TOKEN";

    if (checkoutModel == null ||
        checkoutModel!.services == null ||
        checkoutModel!.services!.isEmpty) {
      print("❌ ERROR: No services selected.");
      hideLoading(context);
      return;
    }

    var selectedService = checkoutModel!.services!.first;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = {
      "services": [
        {
          "service_id": selectedService.serviceId,
          "service_name": "Test Service",
          "required_servicemen": 1,
          "select_serviceman": "as_per_my_choice",
          "address_id": 105,
          "serviceman_id": "91"
        }
      ],
      "date_time": "25-Feb-2025, 10:30 am",
      "payment_method": "wallet",
      "address_id": 105
    };

    print("🚀 Request Data: ${jsonEncode(data)}");

    var dio = Dio();

    try {
      var response = await dio.post(
        api.booking,
        options: Options(headers: headers),
        data: jsonEncode(data), // Ensure it's properly encoded
      );

      if (response.statusCode == 200) {
        print("✅ Booking Successful: ${response.data}");
        onContinue(context);

        // route
        //     .pushNamed(context, routeName.checkoutWebView, arg: response.data)
        //     .then((e) async {
        //   if (e != null && e['isVerify'] == true) {
        //     print("🔹 Payment Verified. Proceeding...");
        //     onContinue(context);
        //   } else {
        //     showLayout(context, response.data['item_id']);
        //   }
        // });
      } else {
        print("❌ API Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("❌ Booking Error: $e");
    } finally {
      hideLoading(context);
    }
  }

  // wlletpayment(context) async {
  //   showLoading(context);
  //   // final cartctrl = provide.of cartprovider context listen

  //   print('🚀 Proceeding to book...');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("accessToken") ?? "NO_TOKEN";
  //   var selectedService = checkoutModel!.services!.first;
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //     'Cookie': 'leadvala_session=cCsw8JCO5V3Qa3f8jkZyUAkeyrKoSoNGvDwxKYRe'
  //   };

  //   var data = json.encode({
  //     "services": [
  //       {
  //         "service_id": selectedService,
  //         "service_name": "Test Service",
  //         "required_servicemen": 1, // Ensure this key is included
  //         "select_serviceman": "as_per_my_choice",
  //         "address_id": 105,
  //         "serviceman_id": "91"
  //       }
  //     ],
  //     "date_time": "",
  //     "payment_method": "wallet",
  //     "address_id": 105
  //   });

  //   print('$data');

  //   var dio = Dio();

  //   try {
  //     var response = await dio.request(
  //       api.booking,
  //       options: Options(
  //         method: 'POST',
  //         headers: headers,
  //       ),
  //       data: data,
  //     );

  //     if (response.statusCode == 200) {
  //       print("✅ Booking Successful: ${response.data}");
  //       print('how is it check in booking ${response.data}');

  //       // route
  //       //     .pushNamed(context, routeName.checkoutWebView, arg: response.data)
  //       //     .then((e) async {
  //       //   print('how is it check in booking ${response.data}');
  //       //   // onContinue(context);

  //       //   if (e != null && e['isVerify'] == true) {
  //       //     print('is verify');
  //       //     onContinue(context);

  //       //     // temp stope this line
  //       //     // await getVerifyPayment(response.data['item_id'], context);
  //       //   } else {
  //       //     showLayout(context, response.data['item_id']);
  //       //   }
  //       // });
  //     } else {
  //       print("❌ API Error: ${response.statusMessage}");
  //     }
  //   } catch (e) {
  //     print("❌ Booking Error: $e");
  //   } finally {
  //     hideLoading(context);
  //   }
  //   print("📌 Request Headers: $headers");
  // }

  void show() {
    print('call11');

    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
  }

  void hide() {
    print('call1');
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
  }

  String? selectedPaymentMethod; // ✅ Declare selected payment method
  int selectedAddressId = 0; // Default value

  void onSelectPaymentMethod(int index, String slug) {
    print('whats your index and slug part$slug');

    // Ensure slug is assigned properly
    if (slug == null || slug.isEmpty) {
      print("❌ Error: Empty or Null Slug - Defaulting to 'cash'");
      slug = "cash";
    }
    selectIndex = index;
    // selectedPaymentMethod = slug;
    selectedPaymentMethod = (slug.isNotEmpty) ? slug : "cash";

    print('✅ Updated Selected Payment Method: $selectedPaymentMethod');
    notifyListeners();
  }

  void setSelectedAddress(int addressId) {
    selectedAddressId = addressId;
    notifyListeners();
  }

  bool isBookingLoading = false; // 🔥 NEW: Track button press loading state

  void setBookingLoading(bool value) {
    isBookingLoading = value;
    notifyListeners();
  }

  // void onSelectPaymentMethod(int index, dynamic slug) {
  //   selectIndex = index; // Store selected index
  //   selectedPaymentMethod = slug; // Store selected payment method
  //   notifyListeners(); // 🔥 Update UI
  // }

  // onSelectPaymentMethod(index, data) {
  //   print('call2');

  //   print('onselectpaymentmethod ${index}');
  //   print('onselectpaymentmethod data ${data}');
  //   selectIndex = index;
  //   isWallet = false;
  //   method = data;
  //   log("selectIndex :$method");
  //   notifyListeners();
  // }
  onContinue(BuildContext context) async {
    print('call3');

    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              isBooked: true,
              title: appFonts.successfullyBooked,
              widget: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(children: [
                        Image.asset(eImageAssets.booked, height: Sizes.s145),
                        SizedBox(
                                height: Sizes.s34,
                                width: Sizes.s34,
                                child: Image.asset(eGifAssets.tick,
                                    height: Sizes.s34, width: Sizes.s34))
                            .paddingOnly(left: Insets.i13, top: Insets.i25)
                      ]))
                  .paddingSymmetric(vertical: Insets.i20)
                  .decorated(
                      color: appColor(context).fieldCardBg,
                      borderRadius: BorderRadius.circular(AppRadius.r10)),
              subtext: appFonts.yourBookingHasBeen,
              bText1: appFonts.goToBookingList,
              height: Sizes.s145,
              b1OnTap: () async {
                print('🔄 Updating Dashboard After Payment');

                method = paymentMethods[0].slug;
                route.pushNamedAndRemoveUntil(context, routeName.dashboard);
                final dash =
                    Provider.of<DashboardProvider>(context, listen: false);

                final common =
                    Provider.of<CommonApiProvider>(context, listen: false);
                common.selfApi(context);
                final wallet =
                    Provider.of<WalletProvider>(context, listen: false);
                wallet.getWalletList(context);
                dash.selectIndex = 1;
                dash.notifyListeners();
                dash.getBookingHistory(context);
                final cartCtrl =
                    Provider.of<CartProvider>(context, listen: false);
                cartCtrl.checkoutModel = null;
                cartCtrl.isPayment = true;
                cartCtrl.cartList = [];
                isWallet = false;
                selectIndex = 0;
                method = null;
                notifyListeners();

                cartCtrl.notifyListeners();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove(session.cart);
                cartCtrl.notifyListeners();
              });
        });
  }

  // onContinue(context) {
  //   print('call3');

  //   showDialog(
  //       context: context,
  //       builder: (context1) {
  //         return AlertDialogCommon(
  //             isBooked: true,
  //             title: appFonts.successfullyBooked,
  //             widget: Container(
  //                     alignment: Alignment.center,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Stack(children: [
  //                       Image.asset(eImageAssets.booked, height: Sizes.s145),
  //                       SizedBox(
  //                               height: Sizes.s34,
  //                               width: Sizes.s34,
  //                               child: Image.asset(eGifAssets.tick,
  //                                   height: Sizes.s34, width: Sizes.s34))
  //                           .paddingOnly(left: Insets.i13, top: Insets.i25)
  //                     ]))
  //                 .paddingSymmetric(vertical: Insets.i20)
  //                 .decorated(
  //                     color: appColor(context).fieldCardBg,
  //                     borderRadius: BorderRadius.circular(AppRadius.r10)),
  //             subtext: appFonts.yourBookingHasBeen,
  //             bText1: appFonts.goToBookingList,
  //             height: Sizes.s145,
  //             b1OnTap: () async {
  //               print('method showing on screen ');
  //               method = paymentMethods[0].slug;
  //               route.pushNamedAndRemoveUntil(context, routeName.dashboard);
  //               final dash =
  //                   Provider.of<DashboardProvider>(context, listen: false);

  //               final common =
  //                   Provider.of<CommonApiProvider>(context, listen: false);
  //               common.selfApi(context);
  //               final wallet =
  //                   Provider.of<WalletProvider>(context, listen: false);
  //               wallet.getWalletList(context);
  //               dash.selectIndex = 1;
  //               dash.notifyListeners();
  //               dash.getBookingHistory(context);
  //               final cartCtrl =
  //                   Provider.of<CartProvider>(context, listen: false);
  //               cartCtrl.checkoutModel = null;
  //               cartCtrl.isPayment = true;
  //               cartCtrl.cartList = [];
  //               isWallet = false;
  //               selectIndex = 0;
  //               method = null;
  //               notifyListeners();

  //               cartCtrl.notifyListeners();
  //               SharedPreferences preferences =
  //                   await SharedPreferences.getInstance();
  //               preferences.remove(session.cart);
  //               cartCtrl.notifyListeners();
  //             });
  //       });
  // }

  onTapWallet(context) async {
    print('call3');

    isWallet = !isWallet;
    notifyListeners();
    if (isWallet) {
      selectIndex = -1;
      selectedPaymentMethod = "wallet"; // 🔥 Ensure this is updated
      print('hhhhhhhhhhwallet$selectedPaymentMethod');
    } else {
      selectedPaymentMethod = null; // Reset when unselected
    }
    notifyListeners();

    // if (isWallet) {
    //   selectIndex = null;
    // }
    // notifyListeners();
  }

  //booking detail by id
  getBookingDetailBy(context) async {
    print('call4');

    print('get booking details');
    try {
      await apiServices
          .getApi("${api.booking}/$bookingId", [], isToken: true, isData: true)
          .then((value) {
        print('hhhhhhhhhhhhhhhhhh${value.data}');
        debugPrint("BOOKING DATA : ${value.data}");

        if (value.isSuccess!) {
          booking = BookingModel.fromJson(value.data);
          notifyListeners();
        }
      });
      log("STATYS L $booking");
    } catch (e) {
      notifyListeners();
    }
  }

  //booking payment
  bookingPayment(context) async {
    print('call5');

    print('call to bookingpayment ');
    try {
      showLoading(context);
      notifyListeners();
      log("bookingId :${booking!.extraCharges}");
      var body = {
        "booking_id": bookingId,
        "payment_method": method,
        "currency_code": currency(context).currency!.code,
        "type": booking!.extraCharges == null || booking!.extraCharges!.isEmpty
            ? "booking"
            : "extra_charge"
      };
      print('call to booking payment::: ${body}');
      log("checkoutBody: $body");
      await apiServices
          .postApi(api.extraPaymentCharge, body, isData: true, isToken: true)
          .then((value) async {
        print('value data showing ?? ${value.data}');
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          route
              .pushNamed(context, routeName.checkoutWebView, arg: value.data)
              .then((e) async {
            log("SSS :$e");
            if (e != null) {
              log("value.data[sss :${value.data}");
              if (e['isVerify'] == true) {
                log("value.data[sdsafdsfs :${value.data}");
                log("value.data[ :${value.data}");
                await getVerifyPayment(value.data['item_id'], context);
              } else {
                log("value.data[sss :${value.data}");
                snackBarMessengers(context,
                    message: "Payment Failed", color: appColor(context).red);
              }
            } else {
              log("value.data[sss :${value.data}");
              snackBarMessengers(context,
                  message: "Payment Failed", color: appColor(context).red);
            }
          });
          notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
        }
      });
    } catch (e) {
      print('booking payment $e');
      hideLoading(context);
      snackBarMessengers(context, message: e);
      notifyListeners();
    }
  }

  //re-payment
  rePayment(context, itemId, {pay}) async {
    print('call5');

    try {
      showLoading(context);
      notifyListeners();
      var body = {
        "item_id": itemId,
        "payment_method": pay ?? method,
        "type": "booking",
        "currency_code": currency(context).currency!.code,
      };

      log("checkoutBody: $body");
      await apiServices
          .postApi(api.repayment, body, isData: true, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          route
              .pushNamed(context, routeName.checkoutWebView, arg: value.data)
              .then((e) async {
            log("SSS :$e");
            if (e != null) {
              log("value.data[sss :${value.data}");
              if (e['isVerify'] == true) {
                log("value.data[sdsafdsfs :${value.data}");
                log("value.data[ :${value.data}");
                await getVerifyPayment(value.data['item_id'], context);
              } else {
                log("value.data[sss :${value.data}");
                snackBarMessengers(context,
                    message: "Payment Failed", color: appColor(context).red);
              }
            } else {
              log("value.data[sss :${value.data}");
              snackBarMessengers(context,
                  message: "Payment Failed", color: appColor(context).red);
            }
          });
          notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      //snackBarMessengers(context, message: e);
      notifyListeners();
    }
  }

  addToCartOrBooking(context) {
    print('how to showing$selectedPaymentMethod');

    if (isRePayment) {
      print('????///${isRePayment}');
      rePayment(context, itemId);
    } else {
      if (selectedPaymentMethod == "cash") {
        wlletpayment(context);
        print('how to showing cash');
        // proceedToBook(context);
      } else if (selectedPaymentMethod == "wallet") {
        print('wallet');
        wlletpayment(context);
      } else {
        proceedToBook(context);
      }
    }
  }

  // if (bookingId == 0) {
  //   print('how to showing');
  //   // proceedToBook(context);
  // } else {
  //   if (method == "cash") {
  //     updateStatus(context, "completed");
  //   } else if (method == "wallet") {
  //     updateStatus(context, "completed");
  //   } else {
  //     log("isRePayment:$isRePayment");
  //     if (isRePayment) {
  //       rePayment(context, itemId);
  //     } else {
  //       bookingPayment(context);
  //     }
  //   }
  // }

  // if (method == "cash") {
  //   updateStatus(context, "completed");
  // } else if (method == "wallet") {
  //   updateStatus(context, "completed");
  // } else {
  //   log("isRePayment:$isRePayment");
  //   if (isRePayment) {
  //     rePayment(context, itemId);
  //   } else {
  //     bookingPayment(context);
  //   }
  // }

  //update status
  updateStatus(context, status, {isCancel = false, sync, id}) async {
    print('call6');

    log("NOCHANGE");
    try {
      showLoading(context);

      notifyListeners();
      dynamic data;
      if (isCancel) {
        route.pop(context);

        data = {
          // "booking_status": "cancel",
          // "reason": "Payment Failed",
        };
      } else {
        data = {"booking_status": status};
      }

      log("ON L$data");
      await apiServices
          .putApi("${api.booking}/${isCancel ? id : booking!.id}", data,
              isToken: true, isData: true)
          .then((value) async {
        log("value.isSuccess!:${value.isSuccess!}");
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          notifyListeners();
          if (status == "completed") {
            isWallet = false;
            selectIndex = 0;
            method = null;
            completeSuccess(context);
          } else {
            log("itemIditemId :$itemId");
            notifyListeners();
            await getVerifyPayment(context, itemId);
            route.pushNamedAndRemoveUntil(context, routeName.dashboard);
            final dash = Provider.of<DashboardProvider>(context, listen: false);
            dash.selectIndex = 1;
            dash.notifyListeners();
            dash.getBookingHistory(context);
            final cartCtrl = Provider.of<CartProvider>(context, listen: false);
            cartCtrl.checkoutModel = null;
            cartCtrl.isPayment = true;
            cartCtrl.cartList = [];
            isWallet = false;
            selectIndex = 0;
            method = null;
            cartCtrl.notifyListeners();
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove(session.cart);
            cartCtrl.notifyListeners();
          }
        } else {
          log("MMEES : ${value.message}");
          snackBarMessengers(context,
              message: value.message, color: appColor(context).red);
        }
      });
      hideLoading(context);
      notifyListeners();
    } catch (e) {
      log("EEEE :$e");
      hideLoading(context);
      snackBarMessengers(context, message: e, color: appColor(context).red);
      notifyListeners();
    }
  }

  completeSuccess(context) {
    print('call7');
    showCupertinoDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              title: appFonts.successfullyComplete,
              height: Sizes.s140,
              image: eGifAssets.successGif,
              subtext: language(context, appFonts.areYouSureComplete),
              bText1: language(context, appFonts.viewBillDetails),
              b1OnTap: () {
                route.pop(context);

                route.pushNamed(context, routeName.completedServiceScreen,
                    arg: {"booking": booking});
              });
        });
  }

  proceedToBook(context) async {
    showLoading(context);

    print('🚀 Proceeding to book...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken") ?? "NO_TOKEN";

    var selectedService = checkoutModel!.services!.first;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print('???..>>>>>>>${selectedService.addressId}');
    print('???..>>>>>>>${selectedService.dateTime}');
    print('???..>>>>>>>${selectedService.providerId}');
    print('???..>>>>>>>${selectedService.total!.total}');
    print('???..>>>>>>>${selectedService.serviceId}');

    var data = json.encode({
      "services": [
        {
          "service_id": selectedService.serviceId,
          "service_name": "Test Service",
          "required_servicemen": 0,
          "select_serviceman": "as_per_my_choice",
          "address_id": 105,
          "date_time": "25-Feb-2025, 10:30 am",
          "serviceman_id": '95'
        }
      ],
      "payment_method": selectedPaymentMethod.toString()
    });
    var dio = Dio();

    try {
      var response = await dio.request(
        api.booking,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print("✅ Booking Successful: ${response.data}");
        print('how is it check in booking ${response.data}');

        route
            .pushNamed(context, routeName.checkoutWebView, arg: response.data)
            .then((e) async {
          print('how is it check in booking ${response.data}');
          // onContinue(context);

          if (e != null && e['isVerify'] == true) {
            print('is verify');
            onContinue(context);

            // temp stope this line
            // await getVerifyPayment(response.data['item_id'], context);
          } else {
            showLayout(context, response.data['item_id']);
          }
        });
      } else {
        print("❌ API Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("❌ Booking Error: $e");
    } finally {
      hideLoading(context);
    }
    print("📌 Request Headers: $headers");
  }

  showLayout(context, id) async {
    print('call9');

    showDialog(
      context: context,
      builder: (context1) {
        return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.selectOne),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]),
              Image.asset(eImageAssets.bulletDotted)
                  .paddingSymmetric(vertical: Insets.i8),
              Text(language(context, appFonts.areYouSureYouWantToCancelBooking),
                  textAlign: TextAlign.center,
                  style: appCss.dmDenseBold18.textColor(appColor(context).red)),
              Image.asset(eImageAssets.bulletDotted)
                  .paddingSymmetric(vertical: Insets.i12),
              Text(language(context, appFonts.optionForOrder),
                  textAlign: TextAlign.center,
                  style: appCss.dmDenseLight14
                      .textColor(appColor(context).darkText)),
              const VSpace(Sizes.s25),
              ...appArray.selectRepaymentOrCancel
                  .asMap()
                  .entries
                  .map((e) => e.value['title'] == appFonts.cashOnDelivery
                      ? appSettingModel!.activation!.cash == "1"
                          ? SelectOrderCancelOrRepayment(
                              data: e.value,
                              index: e.key,
                              list: appArray.selectRepaymentOrCancel,
                              onTap: () {
                                if (e.value['title'] ==
                                    appFonts.cancelBooking) {
                                  itemId = id.toString();
                                  notifyListeners();

                                  updateStatus(context, "cancel",
                                      isCancel: true, id: id);
                                } else if (e.value['title'] ==
                                    appFonts.cashOnDelivery) {
                                  route.pop(context);
                                  rePayment(context, id, pay: "cash");
                                  isRePayment = true;
                                  notifyListeners();
                                  // getImage(context, ImageSource.camera);
                                } else {
                                  route.pop(context);
                                  isRePayment = true;
                                  bookingId = int.parse(id.toString());
                                  itemId = id.toString();
                                  notifyListeners();
                                }
                              })
                          : Container()
                      : SelectOrderCancelOrRepayment(
                          data: e.value,
                          index: e.key,
                          list: appArray.selectRepaymentOrCancel,
                          onTap: () {
                            if (e.value['title'] == appFonts.cancelBooking) {
                              itemId = id.toString();
                              notifyListeners();

                              updateStatus(context, "cancel",
                                  isCancel: true, id: id);
                            } else if (e.value['title'] ==
                                appFonts.cashOnDelivery) {
                              route.pop(context);
                              rePayment(context, id, pay: "cash");
                              isRePayment = true;
                              notifyListeners();
                            } else {
                              route.pop(context);
                              isRePayment = true;
                              itemId = id.toString();
                              notifyListeners();
                            }
                          }))
            ]));
      },
    );
  }

//verify payment
  getVerifyPayment(data, context) async {
    print('call10');

    log("OIIII ssss $data");
    log("OIIII ssss $itemId");
    try {
      String id = itemId ?? data.toString();
      log("VERIIFY L$id");
      await apiServices
          .getApi("${api.verifyPayment}?item_id=$id&type=booking", null,
              isToken: true)
          .then((value) {
        log("CALUE :${value.isSuccess}");
        print('calue ${value.isSuccess}');
        print('calue ${value.message}');
        print('calue ${value.data}');
        log("CALUE :${value.message}");
        method = paymentMethods[0].slug;
        if (value.isSuccess!) {
          print('value id ${value.isSuccess}');
          print('value id ${bookingId}');
          if (bookingId == 0) {
            print('call function to verfication ');
            onContinue(context);
          } else {
            log("OIIII");
            if (itemId == null) {
              updateStatus(context, "completed");
            }
          }
        }
      });
    } catch (e) {
      log("djhsgfkdg getVerifyPayment:$e");
      notifyListeners();
    }
  }
}




/*
dad code finde to the circul of this data 

try {
  showLoading(context);
  notifyListeners();

  // ✅ Ensure checkoutBody is initialized
  if (checkoutBody == null) {
    print('❌ ERROR: checkoutBody is null, initializing it...');
    checkoutBody = {}; // Initialize as empty Map to avoid null error
  }

  var body = Map<String, dynamic>.from(
      checkoutBody); // ✅ Create a copy of checkoutBody

  // ✅ Ensure 'method' is not null
  if (method == null) {
    print('❌ ERROR: payment method is null, setting default...');
    method = "cash"; // Set a default payment method if null
  }

  // body["payment_method"] = isWallet ? "wallet" : method;
  body["services"];
  //  = currency(context).currency?.code ??
  //     "INR"; // Ensure currency_code is not null

  print('✅ Proceeding with body: $body');
  checkoutBody = body;
  notifyListeners();
  print('✅ Proceeding with body22 $checkoutBody');

  log("checkoutBody: $checkoutBody");

  // ✅ Calling API safely
  await apiServices
      .postApi(api.booking, body, isData: true, isToken: true)
      .then((value) async {
    print('✅ API Response: ${value.data}');
    print('✅ API Response: ${value.isSuccess}');
    hideLoading(context);
    notifyListeners();

    if (value.isSuccess!) {
      if (body["payment_method"] == "cash") {
        onContinue(context);
      } else if (body["payment_method"] == "wallet") {
        onContinue(context);
        final wallet = Provider.of<WalletProvider>(context, listen: false);
        wallet.getWalletList(context);
      } else {
        print('✅ Redirecting to Checkout WebView...');
        route
            .pushNamed(context, routeName.checkoutWebView, arg: value.data)
            .then((e) async {
          log("SSS :$e");
          if (e != null && e['isVerify'] == true) {
            await getVerifyPayment(value.data['item_id'], context);
          } else {
            showLayout(context, value.data['item_id']);
          }
        });
      }
    } else {
      log("❌ API Error: ${value.message}");
      flutterAlertMessage(context,
          msg: value.message, bgColor: appColor(context).red);
    }
  });
} catch (e) {
  log("❌ ERROR in proceedToBook: $e");

  flutterAlertMessage(context,
      msg: e.toString(), bgColor: appColor(context).red);
  hideLoading(context);
  notifyListeners();
}

proceedToBook(context) async {
  print('call8');

  print('proceedtobook');
  try {
    print('proceedtobooktry');

    showLoading(context);
    notifyListeners();
    var body = checkoutBody;
    print('pro book body ${body}');
    print('pro method:???  ${method}');=
    body["payment_method"] = isWallet ? "wallet" : method;
    body["currency_code"] = currency(context).currency!.code;
    print('pro book body1 ${body}');
    print(
        'pro book body6 ${body["payment_method"] = isWallet ? "wallet" : method}');
    print(
        'pro book body7 ${body["currency_code"] = currency(context).currency!.code}');
    print('pro book body3 ${method}');
    print('pro book body2 ${checkoutBody}');

    checkoutBody = body;

    notifyListeners();
    log("checkoutBody: $checkoutBody");
    await apiServices
        .postApi(api.booking, body, isData: true, isToken: true)
        .then((value) async {
      print('proceed to book data ${value.data}');
      hideLoading(context);
      notifyListeners();
      log("VA :${value.data}");
      if (value.isSuccess!) {
        if (body["payment_method"] == "cash") {
          onContinue(context);
        } else if (body["payment_method"] == "wallet") {
          onContinue(context);
          final wallet = Provider.of<WalletProvider>(context, listen: false);
          wallet.getWalletList(context);
        } else {
          print('proccedtobook else part ');
          route
              .pushNamed(context, routeName.checkoutWebView, arg: value.data)
              .then((e) async {
            log("SSS :$e");
            if (e != null) {
              log("value.data[sss :${value.data}");
              if (e['isVerify'] == true) {
                log("value.data[sdsafdsfs :${value.data}");
                log("value.data[ :${value.data}");
                await getVerifyPayment(value.data['item_id'], context);
              } else {
                showLayout(context, value.data['item_id']);
              }
            } else {
              showLayout(context, value.data['item_id']);
            }
          });
        }
        notifyListeners();
      } else {
        log("SUCCCC ::;:${value.data} //${value.message}");
        print('else part of catch${value.message} ');
        flutterAlertMessage(context,
            msg: value.message, bgColor: appColor(context).red);
      }
    });
  } catch (e) {
    log("SHHHH:${e}");
    print("SHHHH:${e}");
    flutterAlertMessage(context,
        msg: e.toString(), bgColor: appColor(context).red);
    print('showing to error${e}');
    hideLoading(context);
    notifyListeners();
  }
}
*/
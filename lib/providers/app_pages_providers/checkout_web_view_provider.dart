import 'dart:developer';

import 'package:leadvala/config.dart';
import 'package:leadvala/services/environment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebViewProvider with ChangeNotifier {
  bool isPayment = false, isLoading = true;

  dynamic data;

  WebViewController? controller;
  onReady(BuildContext context) async {
    print('call functon on redy');
    dynamic url = ModalRoute.of(context)?.settings.arguments;

    if (url == null || url is! Map || !url.containsKey("url")) {
      log("❌ Error: No valid URL provided for WebView");
      return;
    }

    data = url;
    print('🔗 Web URL: $url');

    isLoading = true; // ✅ Show loader before loading page
    notifyListeners();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
        onPageStarted: (url) {
          isLoading = true;
          notifyListeners();
        },
        onPageFinished: (url) {
          log("✅ Page Loaded: $url");
          print('call to finse');
          print('call to finse$url');
          isLoading = false;
          notifyListeners();
          print('hellow check payment url $paymentUrl');

          if (url.contains("razorpay_payment_link_status=paid") ||
              url.contains("payment-status=success")) {
            print('🎉 Payment Successful URL detected!');
            handleUrlChanged(context, url);
          }
        },

        // onPageFinished: (url) {
        //   log("✅ Page Loaded: $url");
        //   print('call to finse');
        //   isLoading = false;
        //   notifyListeners();
        //   print('hellow check payment url $paymentUrl');
        //   if (url.contains("/success") ||
        //       url.contains("payment-status=success")) {
        //     print('🎉 Payment Successful URL detected!');
        //     handleUrlChanged(context, url);
        //   }

        //   // if (url.contains(paymentUrl)) {
        //   //   print('call this functon of url ');
        //   //   handleUrlChanged(context, url);
        //   // }
        // },
        onWebResourceError: (error) {
          log("❌ WebView Error: $error");
          isLoading = false;
          notifyListeners();
        },
      ));

    try {
      await controller!.loadRequest(Uri.parse(data["url"]));
    } catch (e) {
      log("❌ Error Loading WebView: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  // onReady(context) async {
  //   dynamic url = ModalRoute.of(context)!.settings.arguments ?? "";
  //   data = url;
  //   print('showing web url $url');
  //   log("URL : $data");
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..loadRequest(Uri.parse(data["url"]))
  //     ..setNavigationDelegate(NavigationDelegate(
  //       onNavigationRequest: (NavigationRequest request) {
  //         return NavigationDecision.navigate;
  //       },
  //       onPageFinished: (url) {
  //         log("URL :$url");
  //         log("URL 1: ${url.contains(paymentUrl)}");
  //         print('URL :$url');

  //         if (url.contains(paymentUrl)) {
  //           handleUrlChanged(context, url);
  //         }
  //       },
  //       onUrlChange: (change) {
  //         isLoading = false;
  //         /* log("change.url! : ${change}");
  //         if (change.url!.contains("/success")) {
  //           isPayment = true;
  //         }*/
  //         notifyListeners();
  //       },
  //       onWebResourceError: (error) {
  //         log("dfhdjkhfg :$error");
  //       },
  //     ));
  //   notifyListeners();
  // }

  // on order success navigate to order success page
  successNavigation(BuildContext context, {data}) async {
    print('🔄 Returning Payment Status to App: $data');

    Future.delayed(Duration(milliseconds: 500), () {
      if (context.mounted) {
        Navigator.pop(context, {"isVerify": data != null, "data": data});
      }
    });
  }

  // successNavigation(context, {data}) async {
  //   print('check to data is succes$data');
  //   log("fhdskjfghdhf:$data");
  //   route.pop(context,
  //       arg: {"isVerify": data == null ? false : true, "data": data});
  // }

  void handleUrlChanged(context, String url) {
    getPaymentTransactionData(context, url);
    print('this function print chek');
    if (url.contains('/member-login/')) {
      log("order-login/");
      route.pop(context);
    }
  }

  getPaymentTransactionData(context, api) async {
    print('📢 Fetching Payment Transaction Data: $api');

    try {
      await apiServices.getApi(api, [], isData: true).then((value) {
        print('✅ Payment API Response: ${value.data}');
        if (value.isSuccess!) {
          if (value.data['payment_status'] == "COMPLETED") {
            print('🎉 Payment is successfully completed!');
            Navigator.pop(context, {"isVerify": true, "data": value});

            // successNavigation(context, data: value.data);
          } else {
            print('⚠️ Payment not completed, closing WebView');
            // successNavigation(context);
            // successNavigation(context, data: value.data);
          }
        }
      });
    } catch (e) {
      print("❌ Error Fetching Payment Data: $e");
      notifyListeners();
    }
  }

  // getPaymentTransactionData(context, api) async {
  //   print('call to get payment transaction');
  //   print('call to get payment transaction$api');
  //   try {
  //     await apiServices.getApi(api, [], isData: true).then((value) {
  //       print('after thend values ${value.data}');
  //       if (value.isSuccess!) {
  //         print('after thend values1 ${value.data}');

  //         /* final items = api.split('/success');
  //         log("items : $items");
  //         final number = items[0].split('/').last;
  //         log("number1 : $number");
  //      */
  //         log("dsfdf :${value.data}");
  //         if (value.data['payment_status'] == "COMPLETED") {
  //           print('value is succes check it ');
  //           successNavigation(context, data: value.data);
  //         } else {
  //           successNavigation(context);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     log("ERRROEEE getProviderById checkout: $e");
  //     notifyListeners();
  //   }
  // }
}

import 'package:webview_flutter/webview_flutter.dart';

import '../../config.dart';

class CheckoutWebView extends StatefulWidget {
  const CheckoutWebView({super.key});

  @override
  State<CheckoutWebView> createState() => CheckoutWebViewState();
}

class CheckoutWebViewState extends State<CheckoutWebView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<CheckoutWebViewProvider>(context, listen: false)
            .onReady(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents default pop behavior
      onPopInvoked: (didPop) async {
        if (didPop) return; // Exit if already popped

        final paymentCtrl =
            Provider.of<CheckoutWebViewProvider>(context, listen: false);

        // ✅ Ensure WebViewController is not null before accessing it
        if (paymentCtrl.controller != null) {
          bool canGoBack = await paymentCtrl.controller!.canGoBack();
          if (canGoBack) {
            paymentCtrl.controller!.goBack();
          } else {
            if (context.mounted) Navigator.pop(context);
          }
        } else {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Consumer<CheckoutWebViewProvider>(
        builder: (context1, paymentCtrl, child) {
          return StatefulWrapper(
            onInit: () => Future.delayed(DurationClass.ms50)
                .then((value) => paymentCtrl.onReady(context)),
            child: Scaffold(
              backgroundColor: appColor(context).whiteColor,
              appBar: AppBarCommon(title: language(context, appFonts.payment)),
              body: Stack(
                children: [
                  if (paymentCtrl.controller != null)
                    WebViewWidget(controller: paymentCtrl.controller!),
                  if (paymentCtrl.isLoading)
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Material(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ).height(MediaQuery.of(context).size.height),
            ),
          );
        },
      ),
    );
  }
}


/*
class CheckoutWebView extends StatefulWidget {
  const CheckoutWebView({super.key});

  @override
  State<CheckoutWebView> createState() => CheckoutWebViewState();
}

Map<dynamic, dynamic>? getPaymentUrl(context) => null;

class CheckoutWebViewState extends State<CheckoutWebView> {
  String? url;
  String? token;
  int selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      return true;
    }, child: Consumer<CheckoutWebViewProvider>(
        builder: (context1, paymentCtrl, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(DurationClass.ms50)
            .then((value) => paymentCtrl.onReady(context)),
        child: Scaffold(
            backgroundColor: appColor(context).whiteColor,
            appBar: AppBarCommon(title: language(context, appFonts.payment)),
            body: Stack(children: [
              if (paymentCtrl.controller != null)
                WebViewWidget(controller: paymentCtrl.controller!),
              if (paymentCtrl.isLoading)
                Container(
                    color: Colors.white,
                    child: Center(
                        child: Material(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3))))))
            ]).height(MediaQuery.of(context).size.height)),
      );
    }));
  }
}
*/
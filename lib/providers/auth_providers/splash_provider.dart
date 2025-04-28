import 'dart:async';
import 'dart:developer';
import 'package:leadvala/models/app_setting_model.dart';

import '../../config.dart';

class SplashProvider extends ChangeNotifier {
  double size = 10;
  double roundSize = 10;
  double roundSizeWidth = 10;
  AnimationController? controller;
  Animation<double>? animation;

  AnimationController? controller2;
  Animation<double>? animation2;

  AnimationController? controller3;
  Animation<double>? animation3;

  AnimationController? controllerSlide;
  Animation<Offset>? offsetAnimation;

  AnimationController? popUpAnimationController;

  onReady(TickerProvider sync, BuildContext context) async {
    bool isAvailable = await isNetworkConnection();
    if (!isAvailable) {
      route.pushReplacementNamed(context, routeName.noInternet);
      return;
    }

    print("🚀 Initializing Splash Screen Animations...");

    controller =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            print("🎬 Main Animation Status: $status");
            if (status == AnimationStatus.completed) {
              print("✅ Main Animation Completed!");
              controller!.stop();
              if (context.mounted) notifyListeners();
            } else if (status == AnimationStatus.dismissed) {
              controller!.forward();
              if (context.mounted) notifyListeners();
            }
          });

    animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
    controller!.forward();

    controller2 =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            print("🎬 Secondary Animation Status: $status");
          });

    animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        print("🎬 Starting Secondary Animation...");
        controller2!.forward();
        notifyListeners();
      }
    });

    controllerSlide =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            print("🎬 Slide Animation Status: $status");
          });

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(controllerSlide!);

    controller3 =
        AnimationController(duration: const Duration(seconds: 2), vsync: sync)
          ..repeat()
          ..addStatusListener((status) {
            print("🎬 Rotation Animation Status: $status");
          });

    animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

    popUpAnimationController =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            print("🎬 Pop-Up Animation Status: $status");
          });

    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        popUpAnimationController!.forward();
        notifyListeners();
      }
    });

    Future.delayed(const Duration(seconds: 5), () async {
      if (context.mounted) {
        onDispose();
      }
    });
  }

/*
  onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();
    if (isAvailable) {
      controller = controller =
          AnimationController(vsync: sync, duration: const Duration(seconds: 2))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                controller!.stop();
                notifyListeners();
              }
              if (status == AnimationStatus.dismissed) {
                controller!.forward();
                notifyListeners();
              }
            });

      animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
      controller!.forward();

      controller2 = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));
      animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

      if (controller2!.status == AnimationStatus.forward ||
          controller2!.status == AnimationStatus.completed) {
        controller2!.reverse();
        notifyListeners();
      } else if (controller2!.status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 2), () {
          controller2!.forward();
          notifyListeners();
        });
      }

      controllerSlide = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      offsetAnimation =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .animate(controllerSlide!);

      controller3 =
          AnimationController(duration: const Duration(seconds: 2), vsync: sync)
            ..repeat();
      animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

      popUpAnimationController = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      Timer(const Duration(seconds: 3), () {
        popUpAnimationController!.forward();
        notifyListeners();
      });

      Timer(const Duration(seconds: 5), () async {
        Provider.of<SplashProvider>(context, listen: false).dispose();
        onDispose();
      });
    } else {
      onDispose();
      Provider.of<SplashProvider>(context, listen: false).dispose();
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }
*/

//setting list
  getAppSettingList(context) async {
    try {
      await apiServices.getApi(api.settings, [], isData: true).then((value) {
        if (value.isSuccess!) {
          appSettingModel = AppSettingModel.fromJson(value.data['values']);

          notifyListeners();
        }
        onUpdate(context, appSettingModel!.general!.defaultCurrency!);
        notifyListeners();
      });
    } catch (e) {
      log("EEEE getAppSettingList $e");
      notifyListeners();
    }
  }

  //setting list
  getPaymentMethodList(context) async {
    print('getpaymethodlist');
    try {
      await apiServices.getApi(api.paymentMethod, []).then((value) {
        print('api responsee check it ${value.data}');
        log("VALUE :${value.data}");
        if (value.isSuccess!) {
          for (var d in value.data) {
            paymentMethods.add(PaymentMethods.fromJson(d));
            print('payment$paymentMethods');
          }
          notifyListeners();
        }

        notifyListeners();
      });
    } catch (e) {
      log("EEEE getPaymentMethodList:$e");
      notifyListeners();
    }
  }

  onUpdate(context, CurrencyModel data) async {
    currency(context).priceSymbol = data.symbol.toString();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    currencyData.currency = data;
    currencyData.currencyVal = data.exchangeRate!;

    currencyData.notifyListeners();
    log("currency(context).priceSymbol : ${currency(context).priceSymbol}");
  }

  void onDispose() {
    print("🛑 Disposing Animations...");

    // ✅ Ensure animations are only disposed once
    controller?.dispose();
    controller = null;

    controller2?.dispose();
    controller2 = null;

    controller3?.dispose();
    controller3 = null;

    controllerSlide?.dispose();
    controllerSlide = null;

    popUpAnimationController?.dispose();
    popUpAnimationController = null;

    print("✅ Animations Disposed Successfully!");
  }

  // onDispose() async {
  //   bool isAvailable = await isNetworkConnection();
  //   if (!isAvailable) {}
  //   controller?.dispose();

  //   controller2?.dispose();
  //   controller3?.dispose();
  //   controllerSlide?.dispose();
  //   popUpAnimationController?.dispose();
  // }

  onChangeSize() {
    size = size == 10 ? 115 : 115;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDispose();
    super.dispose();
  }
}

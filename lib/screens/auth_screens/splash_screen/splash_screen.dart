import 'dart:async';

import '../../../config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  SharedPreferences? pref;
  bool isLoggedIn = false;
  DateTime? animationStartTime;
  DateTime? animationStopTime;
  late AnimationController animationController;
  late SplashProvider splashProvider;

  @override
  void initState() {
    splashProvider = Provider.of<SplashProvider>(context, listen: false);

    Future.microtask(() {
      splashProvider.onReady(this, context);
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print(
              "✅ Animation Completed! Calling `checkLoginStatus(context)`...");
          checkLoginStatus(context);
        }
      });
    calltofastapifunction();

    super.initState();
  }

  calltofastapifunction() async {
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);

    print('🚀 Fetching user details...');
    await commonApi.selfApi(context); // ✅ Ensure this completes first

    print('🚀 Fetching dashboard data...');
    await dashboardProvider.getBanner();
    animationController.forward();
  }

  checkLoginStatus(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
    print("🔍 Is user logged in? $isLoggedIn");

    // Future.delayed(const Duration(milliseconds: 200), () {
    if (isLoggedIn) {
      print('✅ Navigating to Dashboard...');
      route.pushReplacementNamed(context, routeName.dashboard);
    } else {
      print('⚠️ Navigating to Login Screen...');
      Navigator.pushReplacementNamed(context, routeName.login);
    }
    // });
  }

  @override
  void dispose() {
    animationController.dispose(); // ✅ Safely dispose animation
    splashProvider.dispose(); // ✅ Use stored reference instead of Provider.of
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splash, child) {
      return StatefulWrapper(
          onInit: () => Timer(
              const Duration(milliseconds: 200), () => splash.onChangeSize()),
          child: Scaffold(
              body: Center(
                  child: Column(children: [
            Stack(alignment: Alignment.center, children: [
              if (splash.animation2 != null)
                CircularRevealAnimation(
                    animation: splash.animation2!,
                    centerAlignment: Alignment.center,
                    minRadius: 12,
                    maxRadius: 600,
                    child: Container(
                        color: appColor(context).primary.withOpacity(0.7),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Opacity(
                            opacity: 0.15,
                            child: Image.asset(eImageAssets.splashBg,
                                fit: BoxFit.cover)))),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (splash.controller != null) const RotationAnimationLayout(),
                const VSpace(Sizes.s15),
                if (splash.controller != null)
                  if (splash.controller!.isCompleted)
                    SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 2),
                                end: const Offset(0, -0.1))
                            .animate(splash.popUpAnimationController!),
                        child: Text(language(context, appFonts.fixit),
                            style: appCss.outfitSemiBold45
                                .textColor(appColor(context).whiteColor)))
              ])
            ])
          ]))));
    });
  }
}





 // void checkLoginStatus() async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
  //     print("Checking Login Status: $isLoggedIn");

  //     if (isLoggedIn) {
  //       print("User is logged in. Fetching data...");

  //       // Use Future.delayed to ensure context is available
  //       await Future.delayed(Duration(milliseconds: 100));

  //       if (!mounted) return; //  Prevents async context issues

  //       // final commonApi =
  //       //     Provider.of<CommonApiProvider>(context, listen: false);
  //       // await commonApi.selfApi(context);

  //       // final dashboardProvider =
  //       //     Provider.of<DashboardProvider>(context, listen: true);
  //       // // final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
  //       // // await locationCtrl.getZoneId();
  //       // print('call this functio of this ');
  //       // dashboardProvider.getBanner();
  //       // dashboardProvider.getOffer();
  //       // dashboardProvider.getCoupons();
  //       //
  //       // dashboardProvider.getCategory();
  //       // dashboardProvider.getServicePackage();
  //       // dashboardProvider.getProvider();
  //       //
  //       // dashboardProvider.getFeaturedPackage(1);
  //       // dashboardProvider.getHighestRate();
  //       // dashboardProvider.getBlog();

  //       //  Move navigation outside the async call
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         print('ture value check it ');
  //         if (mounted) {
  //           route.pushReplacementNamed(context, routeName.dashboard);
  //         }
  //       });
  //     } else {
  //       print("User is NOT logged in. Redirecting to Login...");

  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         print('flase it  ');

  //         if (mounted) {
  //           Navigator.pushReplacementNamed(context, routeName.login);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("ERROR in checkLoginStatus(): $e");
  //   }
  // }

// temp stope this file

//   void checkLoginStatus(context) async {
//     pref = await SharedPreferences.getInstance();
//     bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
//     print("Is login====${isLoggedIn}");

//     try {
//       if (true) {
//         print('go to the login ');
//         // final dashboardProvider =
//         //     Provider.of<DashboardProvider>(context, listen: true);
//         // final locationCtrl =
//         //     Provider.of<LocationProvider>(context, listen: false);
//         final commonApi =
//             Provider.of<CommonApiProvider>(context, listen: false);
//         print('chcek to the comman api datas${commonApi}');
//         await commonApi.selfApi(context);

//         // await locationCtrl.getZoneId();
//         // dashboardProvider.getBanner();
//         // dashboardProvider.getOffer()
//         // dashboardProvider.getCoupons();
//         //
//         // dashboardProvider.getCategory();
//         // dashboardProvider.getServicePackage();
//         // dashboardProvider.getProvider();
//         //
//         // dashboardProvider.getFeaturedPackage(1);
//         // dashboardProvider.getHighestRate();
//         // dashboardProvider.getBlog();

// // temp stope
//         Future.delayed(const Duration(milliseconds: 500), () {
//           route.pushReplacementNamed(context, routeName.dashboard);
//         });
//       } else {
//         print('go to the fialed ');

//         Future.delayed(const Duration(milliseconds: 500), () {
//           Navigator.pushReplacementNamed(context, routeName.login);
//         });
//       }
//     } catch (e) {
//       print("show me error ----??? $e.toString()");
//     }
//   }



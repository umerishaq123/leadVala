import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/theme/app_theme.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  await initializeFirebase();

// old code
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyAWS3qqwI6od6GZ5rjBm1kxapTF8gRYQuA",
  //         appId: "1:359221399571:android:ebec341250366b4993efe6",
  //         messagingSenderId: "359221399571",
  //         projectId: "leadvala",
  //         storageBucket: "leadvala.firebasestorage.app"));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

Future<void> initializeFirebase() async {
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isNotEmpty) {
      print('⚠️ Firebase is already initialized.');
      return;
    }

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAfyD0--hbTJvB038snS0Mh6F4plsyRPRQ",
        appId: "1:924265223964:android:4fe8ac5037164596c90cd9",
        messagingSenderId: "924265223964",
        projectId: "leadvala-b47d2",
        storageBucket: "leadvala.firebasestorage.app",
      ),
    );

    print('✅ Firebase initialized successfully!');
  } catch (e) {
    print('🚨 Firebase initialization failed: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context1, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(providers: [
              // ChangeNotifierProvider(
              //     create: (_) => ThemeService(snapData.data!, context)),
              ChangeNotifierProvider(
                  create: (_) =>
                      ThemeService(snapData.data!)), // 🔥 Now always Light Mode

              ChangeNotifierProvider(create: (_) => SplashProvider()),
              ChangeNotifierProvider(create: (_) => CommonApiProvider()),
              ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
              ChangeNotifierProvider(create: (_) => LoginProvider()),
              ChangeNotifierProvider(create: (_) => LoginWithPhoneProvider()),
              ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
              ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => RegisterProvider()),
              ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(create: (_) => DashboardProvider()),
              ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(
                  create: (_) => AppSettingProvider(snapData.data!)),
              ChangeNotifierProvider(create: (_) => CurrencyProvider()),
              ChangeNotifierProvider(create: (_) => ProfileDetailProvider()),
              ChangeNotifierProvider(create: (_) => FavouriteListProvider()),
              ChangeNotifierProvider(create: (_) => CommonPermissionProvider()),
              ChangeNotifierProvider(create: (_) => LocationProvider()),
              ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
              ChangeNotifierProvider(create: (_) => MyReviewProvider()),
              ChangeNotifierProvider(create: (_) => EditReviewProvider()),
              ChangeNotifierProvider(create: (_) => AppDetailsProvider()),
              ChangeNotifierProvider(create: (_) => RateAppProvider()),
              ChangeNotifierProvider(create: (_) => ContactUsProvider()),
              ChangeNotifierProvider(create: (_) => NotificationProvider()),
              ChangeNotifierProvider(create: (_) => NewLocationProvider()),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(
                  create: (_) => LatestBLogDetailsProvider()),
              ChangeNotifierProvider(create: (_) => NoInternetProvider()),
              ChangeNotifierProvider(create: (_) => CategoriesListProvider()),
              ChangeNotifierProvider(
                  create: (_) => CategoriesDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ServicesDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ServiceReviewProvider()),
              ChangeNotifierProvider(create: (_) => ProviderDetailsProvider()),
              ChangeNotifierProvider(create: (_) => SlotBookingProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => PaymentProvider()),
              ChangeNotifierProvider(create: (_) => WalletProvider()),
              ChangeNotifierProvider(create: (_) => ServicemanListProvider()),
              ChangeNotifierProvider(create: (_) => ServiceSelectProvider()),
              ChangeNotifierProvider(create: (_) => SelectServicemanProvider()),
              ChangeNotifierProvider(create: (_) => BookingProvider()),
              ChangeNotifierProvider(create: (_) => PendingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AcceptedBookingProvider()),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => OngoingBookingProvider()),
              ChangeNotifierProvider(create: (_) => CompletedServiceProvider()),
              ChangeNotifierProvider(
                  create: (_) => ServicesPackageDetailsProvider()),
              ChangeNotifierProvider(create: (_) => CheckoutWebViewProvider()),
              ChangeNotifierProvider(create: (_) => CancelledBookingProvider()),
              ChangeNotifierProvider(create: (_) => PackageBookingProvider()),
              ChangeNotifierProvider(create: (_) => ServicemanDetailProvider()),
              ChangeNotifierProvider(create: (_) => FeaturedServiceProvider()),
              ChangeNotifierProvider(create: (_) => ExpertServiceProvider()),
              ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
              ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
              ChangeNotifierProvider(
                  create: (_) => LanguageProvider(snapData.data!)),
              ChangeNotifierProvider(
                  create: (_) => ServicePackageAllListProvider()),
            ], child: RouteToPage());
          } else {
            return MaterialApp(
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: const SplashLayout());
          }
        });
  }
}

class RouteToPage extends StatefulWidget {
  const RouteToPage({super.key});

  @override
  State<RouteToPage> createState() => _RouteToPageState();
}

class _RouteToPageState extends State<RouteToPage> {
  @override
  void initState() {
    // CustomNotificationController().initNotification(context);
    //   customnotificationcontroller.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, theme, child) {
      return Consumer<LanguageProvider>(builder: (context, lang, child) {
        return Consumer<CurrencyProvider>(builder: (context, currency, child) {
          return MaterialApp(
              title: 'LeadVala User',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              // theme: AppTheme.fromType(ThemeType.light).themeData,
              theme: AppTheme.fromType(ThemeType.light)
                  .themeData, // 🔥 Light Theme
              // darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
              darkTheme: AppTheme.fromType(ThemeType.light)
                  .themeData, // 🔥 Remove Dark Theme
              locale: lang.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                AppLocalizationDelagate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: appArray.localList,
              themeMode: ThemeMode.light,
              initialRoute: "/",
              routes: appRoute.route);
        });
      });
    });
  }
}

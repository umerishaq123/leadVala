import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:leadvala/config.dart';
import 'package:leadvala/widgets/alert_message_common.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SharedPreferences? pref;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool isPassword = true;
  var dio = Dio();

  onLogin(context) {
    FocusManager.instance.primaryFocus?.unfocus();
    /*  route.pushReplacementNamed(context, routeName.dashboard);*/
    if (formKey.currentState!.validate()) {
      login(context);
    }
  }

  demoCreds() {
    emailController.text = "user@example.com";
    passwordController.text = "123456789";
    notifyListeners();
  }

  // password see tap
  passwordSeenTap() {
    isPassword = !isPassword;
    notifyListeners();
  }

  // SignIn With Google Method
  Future signInWithGoogle(context) async {
    try {
      showLoading(context);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      User? user = (await auth.signInWithCredential(credential)).user;
      socialLogin(context, user!);
      notifyListeners();
    } catch (e) {
      log("kbjhfjuht $e");
      hideLoading(context);
      notifyListeners();
    } finally {
      hideLoading(context);
      notifyListeners();
    }
  }

  socialLogin(context, User user) async {
    showLoading(context);
    notifyListeners();
    String? token = await getFcmToken();
    print('print to $token');
    var body = {
      "login_type": "google",
      "user": {"email": user.email, "name": user.displayName},
      "fcm_token": token
    };

    try {
      await apiServices
          .postApi(api.socialLogin, jsonEncode(body))
          .then((value) async {
        notifyListeners();
        if (value.isSuccess!) {
          pref = await SharedPreferences.getInstance();
          pref!.setBool(session.isContinueAsGuest, false);
          String? token = pref?.getString(session.accessToken);
          log("TOKEN :%sss$token");
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);
          await Future.delayed(DurationClass.ms150);

          hideLoading(context);
          final locationCtrl =
              Provider.of<LocationProvider>(context, listen: false);

          locationCtrl.getUserCurrentLocation(context);
          locationCtrl.getLocationList(context);
          locationCtrl.getCountryState();
          pref!.remove(session.isContinueAsGuest);
          final favCtrl =
              Provider.of<FavouriteListProvider>(context, listen: false);
          favCtrl.getFavourite();
          final cartCtrl = Provider.of<CartProvider>(context, listen: false);
          cartCtrl.onReady(context);
          final notifyCtrl =
              Provider.of<NotificationProvider>(context, listen: false);
          notifyCtrl.getNotificationList(context);
          route.pushReplacementNamed(context, routeName.dashboard);
        } else {
          hideLoading(context);
          notifyListeners();
          snackBarMessengers(context,
              message: value.message, color: appColor(context).red);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("CATCH ff: $e");
    }
  }

  // login(contex) async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var data = json.encode({
  //     "email": "test99@gmail.com",
  //     "password": "123456789",
  //     "fcm_token":
  //         "es8jHB28LPDu-yquGkViap:APA91bFarkljA6-jN0AVemdKAijNzm-SZtuwNz9lcYw_QpupsZWBKQTOEBCMVS7qg4c0SwairDdwpiQezy5nOBx-X0J3wlmt0cdnN7eLLwZWArsqRvvClao"
  //   });
  //   var dio = Dio();
  //   var response = await dio.request(
  //     'https://leadvala.com/api/login',
  //     options: Options(
  //       method: 'POST',
  //       headers: headers,
  //     ),
  //     data: data,
  //   );
  //   // print('showing of response of data ???//??${response.data}');
  //   // if (response.statusCode == 200) {
  //   //   print(json.encode(response.data));
  //   // } else {
  //   //   print(response.statusMessage);
  //   // }
  // }

  // login(context) async {
  //   try {
  //     pref = await SharedPreferences.getInstance();

  //     String? token = await getFcmToken();
  //     print('print to  login fcm token ?>>>1 $token???????? ');
  //     showLoading(context);
  //     var headers = {'Content-Type': 'application/json'};
  //     var body = {
  //       "email": emailController.text,
  //       "password": passwordController.text,
  //       "fcm_token": token
  //     };
  //     print('body ....>>>>${body}');

  //     var response = await dio.request(
  //       'https://leadvala.com/api/login',
  //       options: Options(
  //         method: 'POST',
  //         headers: headers,
  //       ),
  //       data: body,
  //     );
  //     print('response code ${response.statusCode}');
  //   } catch (e) {
  //     print('response code???//??? $e');
  //   }
  // }

  login(context) async {
    print('login function call');
    try {
      pref = await SharedPreferences.getInstance();

      String? token = await getFcmToken();
      print('print to  login fcm token ?>>>1 $token???????? ');
      showLoading(context);
      var body = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": token
      };
      print('body ....>>>>${body}');

      await apiServices
          .postApi(api.login, jsonEncode(body))
          .then((value) async {
        if (value.isSuccess!) {
          pref!.setBool(session.isContinueAsGuest, false);
          pref!.setBool("isLoggedIn", true);

          String? token = pref?.getString(session.accessToken);
          print('not set to the data$token');
          log("TOKEN :%sss$token");
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          print('call to this add');
          if (value.isSuccess!) {
            print("✅ Login successful, calling selfApi...");
            await commonApi.selfApi(context);
          } else {
            print("❌ Login failed, NOT calling selfApi!");
          }
          // await commonApi.selfApi(context);

          dynamic userData = pref!.getString(session.user);
          print('userdata showing???//${userData}');
          if (userData != null) {
            print('nextscreen');
            final locationCtrl =
                Provider.of<LocationProvider>(context, listen: false);
            /*locationCtrl.getUserCurrentLocation(context);*/
            await locationCtrl.getLocationList(context);
            await locationCtrl.getCountryState();
            final favCtrl =
                Provider.of<FavouriteListProvider>(context, listen: false);
            favCtrl.getFavourite();
            final cartCtrl = Provider.of<CartProvider>(context, listen: false);
            cartCtrl.onReady(context);
            final notifyCtrl =
                Provider.of<NotificationProvider>(context, listen: false);
            notifyCtrl.getNotificationList(context);
            pref!.remove(session.isContinueAsGuest);
            // add to this line
            route.pushReplacementNamed(context, routeName.dashboard);
          }
          snackBarMessengers(
            context,
            message: value.message,
            color: appColor(context).primary,
          );
          hideLoading(context);
          emailController.text = "";
          passwordController.text = "";
          route.pushReplacementNamed(context, routeName.dashboard);
          notifyListeners();
        } else {
          print('else part');
          hideLoading(context);
          snackBarMessengers(context,
              message: value.message, color: appColor(context).red);
        }
        print('login data ${value.data}');
      });
    } catch (e) {
      print('showing this error on this time??? $e');
      hideLoading(context);
      notifyListeners();
      log("CATCH login: $e");
    }
  }

  continueAsGuestTap(context) async {
    pref = await SharedPreferences.getInstance();

    pref!.setBool(session.isContinueAsGuest, true);
    log("CCC");
    route.pushReplacementNamed(context, routeName.dashboard);
  }
}

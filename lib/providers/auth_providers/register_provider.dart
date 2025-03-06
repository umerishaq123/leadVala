import 'dart:convert';
import 'dart:developer';

import 'package:country_list_pick/support/code_country.dart';
import 'package:leadvala/config.dart';
import 'package:leadvala/widgets/alert_message_common.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterProvider extends ChangeNotifier {
  bool isNewPassword = true, isConfirmPassword = true, isCheck = false;
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  String dialCode = "+91";
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfirmPass = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  //confirm password see tap
  confirmPasswordSeenTap() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  signUp(context) async {
    print('check to print signup');
    log('check to print login');
    FocusManager.instance.primaryFocus?.unfocus();
    if (isCheck == false) {
      log('user sinup false');
      Fluttertoast.showToast(msg: language(context, appFonts.pleaseCheckTerms));
      /*snackBarMessengers(context, message: appFonts.pleaseCheckTerms);*/
    } else if (registerFormKey.currentState!.validate() && isCheck == true) {
      log('user sinup  using to else if ');

      showLoading(context);
      notifyListeners();
      String token = await getFcmToken();
      print('print to fcmtoken : ? $token');

      var body = {
        "name": txtName.text,
        "email": txtEmail.text,
        "phone": txtPhone.text,
        "code": dialCode,
        "password": txtPass.text,
        "password_confirmation": txtPass.text,
        "fcm_token": token
      };
      print('print token: $token');

      print('print body: $body');

      log("body : $body");

      try {
        log('check to user sign up print');

        await apiServices
            .postApi(api.register, jsonEncode(body))
            .then((value) async {
          hideLoading(context);
          notifyListeners();
          if (value.isSuccess!) {
            txtName.text = "";
            txtEmail.text = "";
            txtPhone.text = "";
            dialCode = "+91";
            txtPass.text = "";
            txtPass.text = "";
            notifyListeners();
            route.pop(context);
          } else {
            snackBarMessengers(context,
                message: value.message, color: appColor(context).red);
          }
        });
      } catch (e) {
        hideLoading(context);
        notifyListeners();
        log("CATCH signUp: $e");
      }
    }
  }

  isCheckBoxCheck(value) {
    isCheck = value;
    notifyListeners();
  }

  onBack() {
    txtName.text = "";
    txtEmail.text = "";
    txtPhone.text = "";
    dialCode = "+91";
    txtPass.text = "";
    txtConfirmPass.text = "";
    notifyListeners();
  }

  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }
}

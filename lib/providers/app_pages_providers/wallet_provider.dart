import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:leadvala/config.dart';
import 'package:leadvala/models/app_setting_model.dart';
import 'package:leadvala/widgets/alert_message_common.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../screens/app_pages_screens/wallet_balance_screen/layouts/add_money_layout.dart';

class WalletProvider with ChangeNotifier {
  List<WalletList> walletList = [];
  String? wallet;
  UserModel? userModel;
  List<PaymentMethods> paymentList = [];
  SharedPreferences? preferences;
  double balance = 0.0;
  bool isGuest = false;

  TextEditingController moneyCtrl = TextEditingController();
  final FocusNode moneyFocus = FocusNode();

  onTapGateway(val) {
    wallet = val;
    notifyListeners();
    log("WALLL :#$wallet");
  }

  onAddMoney(context) {
    print('onAddMoney');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context2) {
        return AddMoneyLayout(buildContext: context);
      },
    ).then((value) async {
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      await commonApi.selfApi(context);

      getWalletList(context);
    });
  }

  getUserDetaild(context) async {
    print('getUserDetail');
    preferences = await SharedPreferences.getInstance();
    print('preferences $preferences');
    isGuest = preferences!.getBool(session.isContinueAsGuest) ?? false;
    print('isGuest $isGuest');

    //Map user = json.decode(preferences!.getString(session.user)!);
    userModel =
        UserModel.fromJson(json.decode(preferences!.getString(session.user)!));
    print('userModel $userModel');

    if (paymentMethods.isNotEmpty) {
      paymentList = paymentMethods;
    } else {
      final common = Provider.of<CommonApiProvider>(context, listen: false);
      await common.getPaymentMethodList(context);
      paymentList = paymentMethods;
    }
    log("paymentList L${paymentList.length}");
    print('paymentList ${paymentList.length}');

    paymentList.removeWhere((element) => element.slug == "cash");
    print('paymentList ${paymentList}');

    wallet = paymentList[0].slug;
    print('paymentList ${wallet}');

    log("paymentList SS${paymentList.length}");
    log("paymentList SS${paymentMethods.length}");
    if (walletList.isEmpty) {
      getWalletList(context);
    }
    notifyListeners();
  }

  getWalletList(context) async {
    print('getWalletList');
    try {
      await apiServices
          .getApi(api.wallet, [], isToken: true, isData: true)
          .then((value) async {
        if (value.isSuccess!) {
          print('getwalletlist???${value.data}');
          log("WALLLL :${value.data}");
          balance = double.parse(value.data['balance'].toString());
          walletList = [];
          for (var data in value.data['transactions']['data']) {
            walletList.add(WalletList.fromJson(data));
          }
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);

          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getProviderById wallet: $e");
      notifyListeners();
    }
  }

  //add to wallet
  addToWallet(context1, context) async {
    print('addToWallet');
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      route.pop(context);
      showLoading(context);
      notifyListeners();
      var body = {
        "amount": moneyCtrl.text,
        "payment_method": wallet,
        "type": "wallet",
        "currency_code": currency(context).currency!.code,
      };

      notifyListeners();
      log("checkoutBody: $body");
      await apiServices
          .postApi(api.addMoneyToWallet, body, isData: true, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          moneyCtrl.text = "";
          wallet = paymentList[0].slug;
          notifyListeners();
          route
              .pushNamed(context, routeName.checkoutWebView, arg: value.data)
              .then((e) async {
            log("SSS :$e");
            if (e != null) {
              if (e['isVerify'] == true) {
                await getWalletList(context);
                await getVerifyPayment(value.data['item_id'], context);
              }
            }
          });
          notifyListeners();
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();

          if (value.message.toLowerCase() == "unauthenticated.") {
            userModel = null;
            setPrimaryAddress = null;
            userPrimaryAddress = null;
            final dash = Provider.of<DashboardProvider>(context, listen: false);
            dash.selectIndex = 0;
            dash.notifyListeners();
            pref.remove(session.user);
            pref.remove(session.accessToken);
            pref.remove(session.isContinueAsGuest);
            pref.remove(session.isLogin);
            pref.remove(session.cart);
            pref.remove(session.recentSearch);

            final auth = FirebaseAuth.instance.currentUser;
            if (auth != null) {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().disconnect();
            }
            notifyListeners();
            route.pushAndRemoveUntil(context);
          } else {
            snackBarMessengers(context, message: value.message);
          }
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
    }
  }

  //verify payment
  getVerifyPayment(data, context) async {
    print('getVerifyPayment');
    try {
      await apiServices
          .getApi("${api.verifyPayment}?item_id=$data&type=wallet", {},
              isToken: true, isData: true)
          .then((value) {
        log("VGHDGHSD : ${value.message}");
        if (value.isSuccess!) {
          if (value.data["payment_status"].toString().toLowerCase() ==
              "pending") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(language(context, appFonts.yourPaymentIsDeclined)),
              backgroundColor: appColor(context).red,
            ));
          } else {
            getWalletList(context);
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}

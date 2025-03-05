import 'dart:convert';
import 'dart:developer';

import 'package:leadvala/common_tap.dart';
import 'package:leadvala/config.dart';
import 'package:leadvala/models/selected_service_cart.dart';

import '../../widgets/alert_message_common.dart';

class ProviderDetailsProvider with ChangeNotifier {
  int selectIndex = 0;
  int selectProviderIndex = 0;
  double widget1Opacity = 0.0;
  List<CategoryModel> categoryList = [];
  List<Services> serviceList = [];
  bool visible = true;
  int val = 1;
  double loginWidth = 100.0;
  int providerId = 0;
  ProviderModel? provider;

  onSelectService(context, index) {
    selectIndex = index;
    notifyListeners();

    getServiceByCategoryId(context, categoryList[index].id);
  }

  onChooseService(index) {
    selectProviderIndex = index;
    notifyListeners();
  }

  onAddService() {
    if (!visible) {
      visible = !visible;
      loginWidth = 100.0;
    } else {
      val = ++val;
    }
    notifyListeners();
  }

  onBack(context, isBack) {
    provider = null;
    widget1Opacity = 0.0;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onReady(context, {id}) async {
    print('showing to the id$id');
    notifyListeners();
    id = id;
    dynamic data;
    if (id != null) {
      data = id;
      print('showing data if1 $data');
    } else {
      data = ModalRoute.of(context)!.settings.arguments;
      print('showing data if2 $data');

      notifyListeners();
      if (data['providerId'] != null) {
        data = data['providerId'];
        print('showing data if3 $data');
      } else {
        provider = data['provider'];
        print('showing data if4 $provider');

        data = provider!.id;
        print('showing data if5 $data');
      }
    }
    notifyListeners();

    await getProviderById(context, 47.toString());
    // await getCategory(context, data);
    widget1Opacity = 1;
    notifyListeners();
  }

  onRemoveService(context, index) async {
    if ((serviceList[index].selectedRequiredServiceMan!) == 1) {
      route.pop(context);
      isAlert = false;
      notifyListeners();
    } else {
      if ((serviceList[index].requiredServicemen!) ==
          (serviceList[index].selectedRequiredServiceMan!)) {
        isAlert = true;
        notifyListeners();
        await Future.delayed(DurationClass.s3);
        isAlert = false;
        notifyListeners();
      } else {
        isAlert = false;
        notifyListeners();
        serviceList[index].selectedRequiredServiceMan =
            ((serviceList[index].selectedRequiredServiceMan!) - 1);
      }
    }
    notifyListeners();
  }

  onAdd(index) {
    isAlert = false;
    notifyListeners();
    int count = (serviceList[index].selectedRequiredServiceMan!);
    count++;
    serviceList[index].selectedRequiredServiceMan = count;
    log("CCCC");
    notifyListeners();
  }

  getProviderById(context, id) async {
    print('showing tot the providerby is$id');
    try {
      await apiServices
          .getApi("${api.provider}/$id", [], isData: true)
          .then((value) {
        print('check out to the value of datas${value.data}');
        if (value.isSuccess!) {
          provider = ProviderModel.fromJson(value.data);
          notifyListeners();
        }
      });
    } catch (e) {
      print('showing error $e');
      log("ERRROEEE getProviderById orovider: $e");
      notifyListeners();
    }
  }

  getCategory(context, id) async {
    print('get categorysd$id');
    // notifyListeners();
    try {
      String apiURL = "${api.category}?providerId=$id";
      print('api url checl it${apiURL}');
      if (zoneIds.isNotEmpty) {
        apiURL = "${api.category}?providerId=$id&zone_ids=$zoneIds";
      } else {
        apiURL = "${api.category}?providerId=$id";
      }

      await apiServices.getApi(apiURL, []).then((value) {
        if (value.isSuccess!) {
          List category = value.data;
          categoryList = [];
          for (var data in category.reversed.toList()) {
            if (!categoryList.contains(CategoryModel.fromJson(data))) {
              categoryList.add(CategoryModel.fromJson(data));
              notifyListeners();
            }
            notifyListeners();
          }
          getServiceByCategoryId(context, categoryList[0].id);
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceByCategoryId(context, categoryList[selectIndex].id);
    hideLoading(context);
  }

  getServiceByCategoryId(context, id) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    notifyListeners();

    try {
      String apiUrl = "${api.service}?categoryIds=$id&zone_ids=$zoneIds";
      log("URRR L: $apiUrl");
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          serviceList = [];
          for (var data in value.data) {
            Services services = Services.fromJson(data);
            if (!serviceList.contains(services)) {
              serviceList.add(services);
            }

            notifyListeners();
          }
        }

        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE getServiceByCategoryId $e");
      notifyListeners();
    }
  }
}

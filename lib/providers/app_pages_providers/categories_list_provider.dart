import 'dart:developer';

import 'package:leadvala/config.dart';

class CategoriesListProvider with ChangeNotifier {
  TextEditingController searchCtrl = TextEditingController();
  bool isGrid = true;
  List<CategoryModel> categoryList = [];
  final FocusNode searchFocus = FocusNode();
  int? selectedIndex;

  List<CategoryModel> demoCategoryList(){
    return [
      CategoryModel(
          id: 1,
          title: "Category 1",
          description: "Category 1 Description",
          media: [
            Media(
                id: 1,
                createdAt: "2021-09-01T00:00:00Z",
                updatedAt: "2021-09-01T00:00:00Z")
          ],
          createdAt: "2021-09-01T00:00:00Z",
          updatedAt: "2021-09-01T00:00:00Z"),
      CategoryModel(
          id: 2,
          title: "Category 2",
          description: "Category 2 Description",
          media: [
            Media(
                id: 2,
                createdAt: "2021-09-01T00:00:00Z",
                updatedAt: "2021-09-01T00:00:00Z")
          ],
          createdAt: "2021-09-01T00:00:00Z",
          updatedAt: "2021-09-01T00:00:00Z"),

    ];
  }
  onGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }

  onBack(context, isBack) {
    searchCtrl.text = "";
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onReady(context, dash) {
    //final dash = Provider.of<DashboardProvider>(context, listen: false);
    categoryList = dash.categoryList;
    notifyListeners();
  }

  searchCategory(context) async {
    try {
      String apiUrl = api.category;
      if (zoneIds.isNotEmpty) {
        if (searchCtrl.text.isNotEmpty) {
          apiUrl = "${api.category}?zone_ids=$zoneIds&search=${searchCtrl.text}";
        } else {
          apiUrl = "${api.category}?zone_ids=$zoneIds";
        }
      } else {
        if (searchCtrl.text.isNotEmpty) {
          apiUrl = "${api.category}&search=${searchCtrl.text}";
        } else {
          apiUrl = api.category;
        }
      }
      log("CATEGIRY");
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          List category = value.data;
          categoryList = [];
          notifyListeners();
          for (var data in category.reversed.toList()) {
            if (!categoryList.contains(CategoryModel.fromJson(data))) {
              categoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        } else {
          categoryList = [];
        }
      });
      log("categoryList :${categoryList.length}");
    } catch (e) {
      notifyListeners();
    }
    notifyListeners();
  }
}

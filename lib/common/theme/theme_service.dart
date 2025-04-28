import '../../config.dart';
import 'app_theme.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  ThemeService(this.sharedPreferences);

  bool get isDarkMode => false; // 🔥 Always return false (Light Mode)

  int get themeIndex => 1; // 🔥 Always use index 1 (Light Theme)

  ThemeMode get theme => ThemeMode.light; // 🔥 Always return light mode

  void switchTheme(isTheme, index) {
    // This function does nothing, as we always force light theme
    notifyListeners();
  }

  AppTheme get appTheme =>
      AppTheme.fromType(ThemeType.light); // 🔥 Force Light Theme
}

// class ThemeService extends ChangeNotifier {
//   final SharedPreferences sharedPreferences;

//   final BuildContext? context;

//   ThemeService(this.sharedPreferences, this.context);

//   bool get isDarkMode => sharedPreferences.getBool(session.isDarkMode) ??
//           MediaQuery.of(context!).platformBrightness == Brightness.dark
//       ? true
//       : false;

//   int get themeIndex => sharedPreferences.getInt(session.themeIndex) ?? 2;

//   ThemeMode get theme => themeIndex == 2
//       ? MediaQuery.of(context!).platformBrightness == Brightness.dark
//           ? ThemeMode.dark
//           : ThemeMode.light
//       : isDarkMode
//           ? ThemeMode.dark
//           : ThemeMode.light;

//   void switchTheme(isTheme, index) {
//     sharedPreferences.setBool(session.isDarkMode, isTheme);
//     sharedPreferences.setInt(
//         session.themeIndex,
//         index == 2
//             ? 2
//             : isDarkMode
//                 ? 0
//                 : 1);
//     notifyListeners();
//   }

//   /// Switch theme and save to local storage
//   AppTheme get appTheme => isDarkMode
//       ? AppTheme.fromType(ThemeType.dark)
//       : AppTheme.fromType(ThemeType.light);
// }

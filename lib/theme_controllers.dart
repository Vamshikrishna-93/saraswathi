import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:student_app/student_app/theme/student_theme.dart';

class StudentThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMode = prefs.getString('student_theme_mode');
    if (savedMode == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    // Sync GetX theme immediately
    Get.changeThemeMode(themeMode.value);
  }

  /// Instantly toggles the theme — UI updates immediately,
  /// persistence happens in the background (no await blocks UI).
  static void toggleTheme() {
    // 1. Update ValueNotifier immediately (synchronous → zero lag)
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    final isDark = themeMode.value == ThemeMode.dark;

    // 2. Apply theme data + mode instantly (synchronous — no delay)
    Get.changeTheme(isDark ? StudentTheme.darkTheme : StudentTheme.lightTheme);
    Get.changeThemeMode(themeMode.value);

    // Force an immediate rebuild of the widget tree
    Get.forceAppUpdate();

    // 3. Persist asynchronously (does NOT block the UI)
    _saveThemePreference(themeMode.value);
  }

  static Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'student_theme_mode',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  void loadTheme() {}
}

class ThemeControllerWrapper extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeController;
  final Widget child;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const ThemeControllerWrapper({
    super.key,
    required this.themeController,
    required this.child,
    this.lightTheme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, child) {
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return Theme(
          // ✅ Default to StudentTheme — student app theme, separate from staff app
          data: isDark
              ? (darkTheme ?? StudentTheme.darkTheme)
              : (lightTheme ?? StudentTheme.lightTheme),
          child: child!,
        );
      },
      child: child,
    );
  }
}

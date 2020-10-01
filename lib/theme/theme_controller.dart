import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/theme/style.dart';

abstract class ThemeController {
  static Future<ThemeData> getSavedThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isDark = prefs.get(GameConstants.THEME_IS_DARK);
    if (isDark != null && isDark) {
      return appThemeData[AppTheme.Dark];
    }
    return appThemeData[AppTheme.Light];
  }

  static Future<ThemeData> changeThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isDark = prefs.get(GameConstants.THEME_IS_DARK);
    if (isDark == null || isDark == false) {
      prefs.setBool(GameConstants.THEME_IS_DARK, true);
      return appThemeData[AppTheme.Dark];
    } else {
      prefs.setBool(GameConstants.THEME_IS_DARK, false);
      return appThemeData[AppTheme.Light];
    }
  }
}

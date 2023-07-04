import 'package:shared_preferences/shared_preferences.dart';

class VisibilityController {
  static const String visibilityKey = 'visible_images';

  Future<bool> getVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(visibilityKey) ?? true;
  }

  Future<void> setVisibility(bool visible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(visibilityKey, visible);
  }
}
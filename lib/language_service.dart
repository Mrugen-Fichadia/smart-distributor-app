import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _isFirstLaunchKey = 'is_first_launch';

  // Supported languages
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'code': 'en',
    },
    'hi': {
      'name': 'Hindi',
      'nativeName': 'हिंदी',
      'flag': '🇮🇳',
      'code': 'hi',
    },
    'gu': {
      'name': 'Gujarati',
      'nativeName': 'ગુજરાતી',
      'flag': '🇮🇳',
      'code': 'gu',
    },
    'mr': {
      'name': 'Marathi',
      'nativeName': 'मराठी',
      'flag': '🇮🇳',
      'code': 'mr',
    },
  };

  // Save selected language
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Get saved language
  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  // Check if it's first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  // Set first launch completed
  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }

  // Get language info
  static Map<String, String> getLanguageInfo(String code) {
    return supportedLanguages[code] ?? supportedLanguages['en']!;
  }
}

import 'package:flutter/material.dart';
import 'language_service.dart';
import 'ml_translation_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  bool _isInitialized = false;
  final MLTranslationService _translationService = MLTranslationService();

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;

  // Initialize the provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Load saved language
    _currentLanguage = await LanguageService.getSavedLanguage();

    // Initialize ML translation service
    await _translationService.initialize();

    _isInitialized = true;
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage == languageCode) return;

    _currentLanguage = languageCode;

    // Save to preferences
    await LanguageService.saveLanguage(languageCode);

    // Download language model if needed
    if (languageCode != MLTranslationService.defaultLanguage) {
      final isDownloaded = await _translationService.isLanguageDownloaded(languageCode);
      if (!isDownloaded) {
        await _translationService.downloadLanguageModel(languageCode);
      }
    }

    notifyListeners();
  }

  // Get language info
  Map<String, String> getLanguageInfo(String code) {
    final language = MLTranslationService.supportedLanguages.firstWhere(
          (lang) => lang['code'] == code,
      orElse: () => MLTranslationService.supportedLanguages.first,
    );

    return {
      'name': language['name'] as String,
      'nativeName': language['nativeName'] as String,
      'flag': language['flag'] as String,
      'code': language['code'] as String,
    };
  }

  // Get all supported languages
  List<Map<String, dynamic>> get supportedLanguages =>
      MLTranslationService.supportedLanguages;

  // Check if language model is downloaded
  Future<bool> isLanguageDownloaded(String languageCode) async {
    return await _translationService.isLanguageDownloaded(languageCode);
  }

  // Download language model
  Future<bool> downloadLanguageModel(String languageCode) async {
    try {
      final result = await _translationService.downloadLanguageModel(languageCode);
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error downloading language model: $e');
      return false;
    }
  }

  // Delete language model
  Future<bool> deleteLanguageModel(String languageCode) async {
    try {
      final result = await _translationService.deleteLanguageModel(languageCode);
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error deleting language model: $e');
      return false;
    }
  }

  // Get downloaded models
  Future<List<String>> getDownloadedModels() async {
    return await _translationService.getDownloadedModels();
  }
}

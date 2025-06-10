import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MLTranslationService {
  // Singleton instance
  static final MLTranslationService _instance = MLTranslationService._internal();
  factory MLTranslationService() => _instance;
  MLTranslationService._internal();

  // Map of language codes to OnDeviceTranslator instances
  final Map<String, OnDeviceTranslator> _translators = {};

  // Map of downloaded language models
  final Map<String, bool> _downloadedModels = {};

  // Cache for translations
  final Map<String, Map<String, String>> _translationCache = {};

  // Default source language (English)
  static const String defaultLanguage = 'en';

  // List of supported languages with their codes
  static final List<Map<String, dynamic>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी', 'flag': '🇮🇳'},
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી', 'flag': '🇮🇳'},
  ];

  // Initialize the service
  Future<void> initialize() async {
    await _loadCachedTranslations();
    await _preloadDownloadStatus();
  }

  // Preload download status for all languages
  Future<void> _preloadDownloadStatus() async {
    try {
      final modelManager = OnDeviceTranslatorModelManager();

      for (var language in supportedLanguages) {
        final languageCode = language['code'];
        if (languageCode == defaultLanguage) {
          _downloadedModels[languageCode] = true;
          continue;
        }

        try {
          final isDownloaded = await modelManager.isModelDownloaded(languageCode);
          _downloadedModels[languageCode] = isDownloaded;
        } catch (e) {
          debugPrint('Error checking if language model is downloaded for $languageCode: $e');
          _downloadedModels[languageCode] = false;
        }
      }
    } catch (e) {
      debugPrint('Error preloading download status: $e');
    }
  }

  // Load cached translations from SharedPreferences
  Future<void> _loadCachedTranslations() async {
    final prefs = await SharedPreferences.getInstance();

    for (var language in supportedLanguages) {
      final languageCode = language['code'];
      if (languageCode == defaultLanguage) continue;

      final cacheKey = 'translations_$languageCode';
      final cachedData = prefs.getStringList(cacheKey);

      if (cachedData != null && cachedData.isNotEmpty) {
        _translationCache[languageCode] = {};

        for (int i = 0; i < cachedData.length; i += 2) {
          if (i + 1 < cachedData.length) {
            final key = cachedData[i];
            final value = cachedData[i + 1];
            _translationCache[languageCode]![key] = value;
          }
        }

        debugPrint('Loaded ${_translationCache[languageCode]!.length} cached translations for $languageCode');
      }
    }
  }

  // Save translations to SharedPreferences
  Future<void> _saveCachedTranslations(String languageCode) async {
    if (!_translationCache.containsKey(languageCode)) return;

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'translations_$languageCode';

    final List<String> cacheData = [];
    _translationCache[languageCode]!.forEach((key, value) {
      cacheData.add(key);
      cacheData.add(value);
    });

    await prefs.setStringList(cacheKey, cacheData);
    debugPrint('Saved ${_translationCache[languageCode]!.length} translations for $languageCode');
  }

  // Get a translator for the specified language
  Future<OnDeviceTranslator> _getTranslator(String targetLanguage) async {
    if (_translators.containsKey(targetLanguage)) {
      return _translators[targetLanguage]!;
    }

    // Create a new translator
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.values.firstWhere(
            (element) => element.bcpCode == defaultLanguage,
      ),
      targetLanguage: TranslateLanguage.values.firstWhere(
            (element) => element.bcpCode == targetLanguage,
      ),
    );

    _translators[targetLanguage] = translator;
    return translator;
  }

  // Check if a language model is downloaded
  Future<bool> isLanguageDownloaded(String languageCode) async {
    if (_downloadedModels.containsKey(languageCode)) {
      return _downloadedModels[languageCode]!;
    }

    try {
      final modelManager = OnDeviceTranslatorModelManager();
      final isDownloaded = await modelManager.isModelDownloaded(languageCode);
      _downloadedModels[languageCode] = isDownloaded;
      return isDownloaded;
    } catch (e) {
      debugPrint('Error checking if language model is downloaded: $e');
      return false;
    }
  }

  // Download a language model
  Future<bool> downloadLanguageModel(String languageCode, {Function(double)? onProgress}) async {
    try {
      final modelManager = OnDeviceTranslatorModelManager();

      // Check if already downloaded
      if (await isLanguageDownloaded(languageCode)) {
        return true;
      }

      // Download the model
      bool result = await modelManager.downloadModel(
        languageCode,
        isWifiRequired: false,
      );

      if (result) {
        _downloadedModels[languageCode] = true;
      }

      return result;
    } catch (e) {
      debugPrint('Error downloading language model: $e');
      return false;
    }
  }

  // Delete a language model
  Future<bool> deleteLanguageModel(String languageCode) async {
    try {
      final modelManager = OnDeviceTranslatorModelManager();
      bool result = await modelManager.deleteModel(languageCode);

      if (result) {
        _downloadedModels[languageCode] = false;

        // Remove the translator if it exists
        if (_translators.containsKey(languageCode)) {
          await _translators[languageCode]!.close();
          _translators.remove(languageCode);
        }
      }

      return result;
    } catch (e) {
      debugPrint('Error deleting language model: $e');
      return false;
    }
  }

  // Check if we have a cached translation
  bool hasCachedTranslation(String text, String languageCode) {
    return _translationCache.containsKey(languageCode) &&
        _translationCache[languageCode]!.containsKey(text);
  }

  // Get a cached translation
  String? getCachedTranslation(String text, String languageCode) {
    if (hasCachedTranslation(text, languageCode)) {
      return _translationCache[languageCode]![text];
    }
    return null;
  }

  // Cache a translation
  void cacheTranslation(String text, String translation, String languageCode) {
    if (!_translationCache.containsKey(languageCode)) {
      _translationCache[languageCode] = {};
    }

    _translationCache[languageCode]![text] = translation;

    // Save to persistent storage (don't await to avoid blocking)
    _saveCachedTranslations(languageCode);
  }

  // Translate text
  Future<String> translateText(String text, String targetLanguage) async {
    // Skip translation if target is the default language
    if (targetLanguage == defaultLanguage) {
      return text;
    }

    // Check cache first
    final cachedTranslation = getCachedTranslation(text, targetLanguage);
    if (cachedTranslation != null) {
      return cachedTranslation;
    }

    try {
      // Ensure the language model is downloaded
      if (!await isLanguageDownloaded(targetLanguage)) {
        await downloadLanguageModel(targetLanguage);
      }

      // Get the translator
      final translator = await _getTranslator(targetLanguage);

      // Translate the text
      final translation = await translator.translateText(text);

      // Cache the translation
      cacheTranslation(text, translation, targetLanguage);

      return translation;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text; // Return original text on error
    }
  }

  // Get all downloaded models
  Future<List<String>> getDownloadedModels() async {
    List<String> downloadedModels = [];

    for (var language in supportedLanguages) {
      final languageCode = language['code'];
      if (languageCode == defaultLanguage) continue;

      if (await isLanguageDownloaded(languageCode)) {
        downloadedModels.add(languageCode);
      }
    }

    return downloadedModels;
  }

  // Get storage size for a language model
  Future<int> getModelSize(String languageCode) async {
    try {
      // This is an approximation as ML Kit doesn't provide exact size
      return 30 * 1024 * 1024; // ~30MB per model
    } catch (e) {
      return 0;
    }
  }

  // Close all translators
  Future<void> dispose() async {
    for (var translator in _translators.values) {
      await translator.close();
    }
    _translators.clear();
  }
}

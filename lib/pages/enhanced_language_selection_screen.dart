import 'package:flutter/material.dart';
import 'package:smart_distributor_app/language_provider.dart';
import 'package:smart_distributor_app/ml_translation_service.dart';
import 'package:smart_distributor_app/localized_text.dart';
import 'package:smart_distributor_app/app_colours.dart';
import 'package:smart_distributor_app/language_service.dart';
import 'home.dart';
import 'package:provider/provider.dart';

class EnhancedLanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const EnhancedLanguageSelectionScreen({
    Key? key,
    this.isFromSettings = false,
  }) : super(key: key);

  @override
  State<EnhancedLanguageSelectionScreen> createState() => _EnhancedLanguageSelectionScreenState();
}

class _EnhancedLanguageSelectionScreenState extends State<EnhancedLanguageSelectionScreen>
    with TickerProviderStateMixin {
  String _selectedLanguage = 'en';
  Map<String, bool> _downloadStatus = {};
  Map<String, double> _downloadProgress = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadLanguageStatus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _loadLanguageStatus() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    _selectedLanguage = languageProvider.currentLanguage;

    // Check download status for all languages
    for (var language in MLTranslationService.supportedLanguages) {
      final code = language['code'];
      if (code == MLTranslationService.defaultLanguage) {
        _downloadStatus[code] = true;
        continue;
      }

      final isDownloaded = await languageProvider.isLanguageDownloaded(code);
      setState(() {
        _downloadStatus[code] = isDownloaded;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (!widget.isFromSettings) ...[
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                  ] else ...[
                    const SizedBox(height: 20),
                    _buildSettingsHeader(),
                    const SizedBox(height: 30),
                  ],
                  Expanded(
                    child: _buildLanguageList(),
                  ),
                  const SizedBox(height: 24),
                  _buildContinueButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.translate,
            size: 60,
            color: AppColors.primaryMaroon,
          ),
        ),
        const SizedBox(height: 24),
        const LocalizedText(
          text: 'Select Language',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMaroon,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose your preferred language for translation',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.darkGray,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingsHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryMaroon,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        const LocalizedText(
          text: 'Change Language',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMaroon,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: MLTranslationService.supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = MLTranslationService.supportedLanguages[index];
          final languageCode = language['code'];
          final isSelected = _selectedLanguage == languageCode;
          final isDownloaded = _downloadStatus[languageCode] ?? false;
          final downloadProgress = _downloadProgress[languageCode] ?? 0.0;

          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 50)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.lightMaroon.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryMaroon : Colors.transparent,
                width: 2,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryMaroon : Colors.grey[100],
                  shape: BoxShape.circle,
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.primaryMaroon.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    language['flag'],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              title: Text(
                language['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primaryMaroon : AppColors.darkGray,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language['nativeName'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? AppColors.primaryMaroon.withOpacity(0.7) : AppColors.darkGray.withOpacity(0.7),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (languageCode != MLTranslationService.defaultLanguage) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isDownloaded ? Icons.check_circle : Icons.download,
                          size: 14,
                          color: isDownloaded ? Colors.green : AppColors.lightMaroon,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isDownloaded ? 'Downloaded' : 'Download required',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDownloaded ? Colors.green : AppColors.lightMaroon,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (downloadProgress > 0 && downloadProgress < 1) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: downloadProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMaroon),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ],
              ),
              trailing: isSelected
                  ? Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryMaroon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              )
                  : null,
              onTap: () => _selectLanguage(languageCode),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _onContinuePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMaroon,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: AppColors.primaryMaroon.withOpacity(0.4),
        ),
        child: const LocalizedText(
          text: 'Continue',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  void _selectLanguage(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Download language model if needed
    if (languageCode != MLTranslationService.defaultLanguage &&
        !(_downloadStatus[languageCode] ?? false)) {
      await _downloadLanguageModel(languageCode);
    }

    _animateSelection();
  }

  Future<void> _downloadLanguageModel(String languageCode) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    setState(() {
      _downloadProgress[languageCode] = 0.1;
    });

    try {
      // Simulate progress updates
      for (int i = 2; i <= 9; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _downloadProgress[languageCode] = i / 10;
        });
      }

      final success = await languageProvider.downloadLanguageModel(languageCode);

      setState(() {
        _downloadStatus[languageCode] = success;
        _downloadProgress[languageCode] = success ? 1.0 : 0.0;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Language model downloaded successfully',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _downloadProgress[languageCode] = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to download language model',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _animateSelection() {
    _animationController.reset();
    _animationController.forward();
  }

  void _onContinuePressed() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    // Change language
    await languageProvider.changeLanguage(_selectedLanguage);

    if (!widget.isFromSettings) {
      // Mark first launch as completed
      await LanguageService.setFirstLaunchCompleted();

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(

          ),
        ),
      );
    } else {
      // Return to previous screen with success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const LocalizedText(text: 'Language changed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}

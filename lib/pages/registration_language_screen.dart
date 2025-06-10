import 'package:flutter/material.dart';
import 'package:smart_distributor_app/language_provider.dart';
import 'package:smart_distributor_app/ml_translation_service.dart';
import 'package:smart_distributor_app/localized_text.dart';
import 'package:smart_distributor_app/app_colours.dart';
import 'home.dart';
import 'package:smart_distributor_app/language_service.dart';
import 'package:provider/provider.dart';

class RegistrationLanguageScreen extends StatefulWidget {
  final Function(String) onLanguageSelected;

  const RegistrationLanguageScreen({
    Key? key,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  State<RegistrationLanguageScreen> createState() => _RegistrationLanguageScreenState();
}

class _RegistrationLanguageScreenState extends State<RegistrationLanguageScreen>
    with TickerProviderStateMixin {
  String _selectedLanguage = 'en';
  Map<String, bool> _downloadStatus = {};
  bool _isDownloading = false;
  String _downloadingLanguage = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int _currentPage = 0;

  // Enhanced download animation controllers
  late AnimationController _downloadAnimationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadLanguageStatus();
    _pageController = PageController();
  }

  void _setupAnimations() {
    // Main screen animations
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

    // Simple download animation
    _downloadAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animationController.forward();
  }

  void _startDownloadAnimations() {
    _downloadAnimationController.repeat();
  }

  void _stopDownloadAnimations() {
    _downloadAnimationController.stop();
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
      if (mounted) {
        setState(() {
          _downloadStatus[code] = isDownloaded;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _downloadAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          _buildWelcomePage(),
                          _buildLanguageSelectionPage(),
                        ],
                      ),
                    ),
                    _buildPageIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _currentPage == 0
                          ? _buildNextButton()
                          : _buildContinueButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Enhanced download overlay
          if (_isDownloading)
            _buildEnhancedDownloadOverlay(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryMaroon.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Adjust padding to fit the image nicely
              child: Image.asset(
                'assets/images/logo.png', // Replace with your image path
                fit: BoxFit.contain, // Ensure the image fits within the container
              ),
            ),
          ),
          const SizedBox(height: 40),
          const LocalizedText(
            text:'Welcome to Smart Distributor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const LocalizedText(
            text:'Let\'s start by selecting your preferred language',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.darkGray,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const LocalizedText(
           text: 'Choose Your Language',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const LocalizedText(
            text:  'Select the language you are most comfortable with',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkGray,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildLanguageGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: MLTranslationService.supportedLanguages.length,
      itemBuilder: (context, index) {
        final language = MLTranslationService.supportedLanguages[index];
        final languageCode = language['code'];
        final isSelected = _selectedLanguage == languageCode;
        final isDownloaded = _downloadStatus[languageCode] ?? false;
        final isDownloading = _isDownloading && _downloadingLanguage == languageCode;

        return GestureDetector(
          onTap: () => _selectLanguage(languageCode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.lightMaroon.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryMaroon : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.primaryMaroon.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  language['flag'],
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  language['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primaryMaroon : AppColors.darkGray,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  language['nativeName'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.primaryMaroon.withOpacity(0.7) : AppColors.darkGray.withOpacity(0.7),
                    fontFamily: 'Poppins',
                  ),
                ),
                if (languageCode != MLTranslationService.defaultLanguage) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDownloaded ? Icons.check_circle : Icons.download,
                        size: 12,
                        color: isDownloaded ? Colors.green : AppColors.lightMaroon,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isDownloaded ? 'Ready' : 'Download',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDownloaded ? Colors.green : AppColors.lightMaroon,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIndicator(0),
        const SizedBox(width: 8),
        _buildIndicator(1),
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primaryMaroon : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
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
          text: 'Next',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedDownloadOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple spinning circle
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMaroon),
                ),
              ),
              const SizedBox(height: 24),
              // Download message with language name
              LocalizedText(
                text: 'Download ${_getLanguageName(_downloadingLanguage)}\nplease wait',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Rounded cancel button
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: _cancelDownload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: AppColors.darkGray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const LocalizedText(
                    text: 'Cancel',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    final language = MLTranslationService.supportedLanguages.firstWhere(
          (lang) => lang['code'] == languageCode,
      orElse: () => {'name': 'Language'},
    );
    return language['name'] as String;
  }

  void _cancelDownload() {
    _stopDownloadAnimations();
    setState(() {
      _isDownloading = false;
      _downloadingLanguage = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const LocalizedText(
          text:  'Download cancelled',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
  }

  Future<void> _downloadLanguageModel(String languageCode) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    setState(() {
      _isDownloading = true;
      _downloadingLanguage = languageCode;
    });

    try {
      // Perform the actual download
      final success = await languageProvider.downloadLanguageModel(languageCode);

      // Update UI after download completes
      if (mounted) {
        setState(() {
          _downloadStatus[languageCode] = success;
          _isDownloading = false;
          _downloadingLanguage = '';
        });
      }

      if (success) {
        // Update language in provider
        await languageProvider.changeLanguage(languageCode);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const LocalizedText(
              text: 'Language downloaded successfully',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const LocalizedText(
              text:  'Failed to download language model',
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
    } catch (e) {
      // Handle errors
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadingLanguage = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: LocalizedText(
              text:  'Error downloading language: $e',
              style: const TextStyle(fontFamily: 'Poppins'),
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
  }

  void _onContinuePressed() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    try {
      // Check if we need to download the language model
      final needsDownload = _selectedLanguage != MLTranslationService.defaultLanguage &&
          !(_downloadStatus[_selectedLanguage] ?? false);

      if (needsDownload) {
        // Only show download screen if we actually need to download
        setState(() {
          _isDownloading = true;
          _downloadingLanguage = _selectedLanguage;
        });

        // Perform the actual download
        final success = await languageProvider.downloadLanguageModel(_selectedLanguage);

        if (!success) {
          // Show error message and return if download failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const LocalizedText(
                text:  'Failed to download language model',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          setState(() {
            _isDownloading = false;
            _downloadingLanguage = '';
          });

          return;
        }
      }

      // Ensure language is set
      await languageProvider.changeLanguage(_selectedLanguage);

      // Mark first launch as completed
      await LanguageService.setFirstLaunchCompleted();

      // Hide loading indicator if it was shown
      if (_isDownloading && mounted) {
        setState(() {
          _isDownloading = false;
          _downloadingLanguage = '';
        });
      }

      // Call the callback
      widget.onLanguageSelected(_selectedLanguage);

      // Navigate directly to home screen with smooth transition
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(

          ),
        ),
      );

    } catch (e) {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadingLanguage = '';
        });
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: LocalizedText(
            text:  'Failed to proceed: $e',
            style: const TextStyle(fontFamily: 'Poppins'),
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
}

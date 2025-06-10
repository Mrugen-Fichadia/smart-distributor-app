import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/registration_language_screen.dart';
import 'pages//enhanced_language_selection_screen.dart';
import '/language_provider.dart';
import '/language_service.dart';
import '/app_colours.dart';
import '/localized_text.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Smart Distributor App',
            theme: ThemeData(
              primaryColor: AppColors.primaryMaroon,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryMaroon,
                primary: AppColors.primaryMaroon,
                secondary: AppColors.lightMaroon,
                background: AppColors.offWhite,
              ),
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme.apply(
                  bodyColor: AppColors.darkGray,
                  displayColor: AppColors.darkGray,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: AppColors.primaryMaroon,
                    width: 2.0,
                  ),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMaroon,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeApp() async {
    // Initialize language provider
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await languageProvider.initialize();

    // Check if it's first launch
    final isFirstLaunch = await LanguageService.isFirstLaunch();

    Timer(const Duration(seconds: 3), () {
      if (isFirstLaunch) {
        // Show registration language screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationLanguageScreen(
              onLanguageSelected: (language) {
                // Navigate to auth screen after language selection
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationLanguageScreen(
                      onLanguageSelected: (selectedLanguage) {
                        // Handle the selected language here
                        print('Selected language: $selectedLanguage');

                        // You can also update your app state or call setState here if needed
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        // Show auth screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationLanguageScreen(
              onLanguageSelected: (selectedLanguage) {
                // Handle the selected language here
                print('Selected language: $selectedLanguage');

                // You can also update your app state or call setState here if needed
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(75),
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
                    const SizedBox(height: 30),
                    const LocalizedText(
                      text: 'Smart Distributor App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryMaroon,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const LocalizedText(
                      text: 'LPG Distribution Made Easy',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightMaroon),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Placeholder for AuthScreen
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocalizedText(text: 'Login'),
        backgroundColor: AppColors.primaryMaroon,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnhancedLanguageSelectionScreen(
                    isFromSettings: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LocalizedText(
                text: 'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const LocalizedText(text: 'Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

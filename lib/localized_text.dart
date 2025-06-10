import 'package:flutter/material.dart';
import 'ml_translation_service.dart';
import 'language_provider.dart';
import 'app_colours.dart';
import 'package:provider/provider.dart';

class LocalizedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final bool showLoadingIndicator;

  const LocalizedText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.showLoadingIndicator = false,
  }) : super(key: key);

  @override
  _LocalizedTextState createState() => _LocalizedTextState();
}

class _LocalizedTextState extends State<LocalizedText> {
  String? _translatedText;
  bool _isLoading = true;
  late MLTranslationService _translationService;
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _translationService = MLTranslationService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (languageProvider.isInitialized) {
      _currentLanguage = languageProvider.currentLanguage;
      _translateText();
    }
  }

  @override
  void didUpdateWidget(LocalizedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final newLanguage = languageProvider.currentLanguage;

    if (oldWidget.text != widget.text || _currentLanguage != newLanguage) {
      _currentLanguage = newLanguage;
      _translateText();
    }
  }

  Future<void> _translateText() async {
    if (_currentLanguage == MLTranslationService.defaultLanguage) {
      setState(() {
        _translatedText = widget.text;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final translation = await _translationService.translateText(
        widget.text,
        _currentLanguage,
      );

      if (mounted) {
        setState(() {
          _translatedText = translation;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error translating text: $e');
      if (mounted) {
        setState(() {
          _translatedText = widget.text; // Fallback to original text
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show original text while loading translation
    final textToShow = _isLoading ? widget.text : (_translatedText ?? widget.text);

    // Default text style with app colors
    final TextStyle defaultStyle = TextStyle(
      color: AppColors.darkGray,
      fontFamily: 'Poppins',
    );

    // Merge default style with provided style
    final TextStyle mergedStyle = widget.style != null
        ? defaultStyle.merge(widget.style)
        : defaultStyle;

    if (_isLoading && widget.showLoadingIndicator) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textToShow,
            style: mergedStyle,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            softWrap: widget.softWrap,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryMaroon,
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      textToShow,
      style: mergedStyle,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderSettings {
  final double fontSizeScale;
  final double lineHeight;
  final String fontFamily;

  const ReaderSettings({
    this.fontSizeScale = 1.0,
    this.lineHeight = 1.6,
    this.fontFamily = 'Sans', 
  });

  ReaderSettings copyWith({
    double? fontSizeScale,
    double? lineHeight,
    String? fontFamily,
  }) {
    return ReaderSettings(
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

class ReaderSettingsController extends Notifier<ReaderSettings> {
  @override
  ReaderSettings build() {
    // TODO: Later load this from SharedPreferences
    return const ReaderSettings();
  }

  void setFontSize(double scale) {
    // Clamp between 0.8 (tiny) and 2.0 (huge)
    state = state.copyWith(fontSizeScale: scale.clamp(0.8, 2.0));
  }

  void setLineHeight(double height) {
    state = state.copyWith(lineHeight: height);
  }

  void toggleFontFamily() {
    state = state.copyWith(
      fontFamily: state.fontFamily == 'Sans' ? 'Serif' : 'Sans',
    );
  }
}

final readerSettingsProvider = 
    NotifierProvider<ReaderSettingsController, ReaderSettings>(() {
  return ReaderSettingsController();
});
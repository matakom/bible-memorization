import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Configuration for the visual appearance of the Bible reader.
class ReaderSettings {
  final double fontSizeScale;
  final double lineHeight;
  final String fontFamily;

  const ReaderSettings({
    required this.fontSizeScale,
    required this.lineHeight,
    required this.fontFamily,
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

/// Manages the loading and persistence of reader UI preferences.
class ReaderSettingsController extends AsyncNotifier<ReaderSettings> {
  static const _fsKey = 'reader_font_size_scale';
  static const _lhKey = 'reader_line_height';
  static const _ffKey = 'reader_font_family';

  @override
  Future<ReaderSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return ReaderSettings(
      fontSizeScale: prefs.getDouble(_fsKey) ?? 1.0,
      lineHeight: prefs.getDouble(_lhKey) ?? 1.6,
      fontFamily: prefs.getString(_ffKey) ?? 'Sans',
    );
  }

  Future<void> setFontSize(double scale) async {
    final newScale = scale.clamp(0.8, 2.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fsKey, newScale);
    state = AsyncData(state.value!.copyWith(fontSizeScale: newScale));
  }

  Future<void> setLineHeight(double height) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lhKey, height);
    state = AsyncData(state.value!.copyWith(lineHeight: height));
  }

  Future<void> toggleFontFamily() async {
    final newFamily = state.value!.fontFamily == 'Sans' ? 'Serif' : 'Sans';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ffKey, newFamily);
    state = AsyncData(state.value!.copyWith(fontFamily: newFamily));
  }
}

final readerSettingsProvider = 
    AsyncNotifierProvider<ReaderSettingsController, ReaderSettings>(ReaderSettingsController.new);
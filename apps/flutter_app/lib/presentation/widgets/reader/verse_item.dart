import 'package:flutter/material.dart';
import '../../../providers/reader_provider.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_dimens.dart';

class VerseItem extends StatelessWidget {
  final ReaderVerseState state;
  final VoidCallback onTap;

  const VerseItem({super.key, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSaved = state.isSaved;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Container(
        padding: const EdgeInsets.all(AppSpacings.m),
        decoration: BoxDecoration(
          color: isSaved ? AppPalette.primary.withOpacity(0.15) : Colors.transparent,
          border: isSaved 
              ? Border.all(color: AppPalette.primary, width: 1.5)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Number
            Text(
              '${state.verse.verse}', // Ensure Verse class uses verseNumber
              style: AppTypography.caption.copyWith(
                color: isSaved ? AppPalette.primary : AppPalette.textSecondaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.horizontalM,
            // Text
            Expanded(
              child: Text(
                state.verse.text,
                style: AppTypography.body.copyWith(
                  height: 1.6,
                  color: isSaved ? Colors.black87 : null, // Better contrast when selected
                ),
              ),
            ),
            if (isSaved) ...[
              Spacing.horizontalS,
              const Icon(Icons.check_circle, color: AppPalette.primary, size: 20),
            ]
          ],
        ),
      ),
    );
  }
}
import 'verse.dart';
import 'sm2_stats.dart';
import 'hlr_stats.dart';

/// Represents immutable verse and additional stats for spaced repetition.
class SavedVerse {
  final String id;
  final Verse verse; // Verse reference
  final DateTime nextReviewDate;
  
  // Data for spaced repetition
  final Sm2Stats sm2Stats;
  final HlrStats? hlrStats;

  SavedVerse({
    required this.id,
    required this.verse,
    required this.nextReviewDate,
    required this.sm2Stats,
    this.hlrStats,
  });

  factory SavedVerse.fromJoinedMap(Map<String, dynamic> map) {
    return SavedVerse(
      id: map['id'],
      nextReviewDate: DateTime.parse(map['next_review_date']),
      verse: Verse.fromMap(map),
      sm2Stats: Sm2Stats.fromMap(map),
      hlrStats: map.containsKey('calculated_half_life') ? HlrStats.fromMap(map) : null,
    );
  }
}
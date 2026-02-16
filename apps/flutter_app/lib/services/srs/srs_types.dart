import '../../data/models/sm2_stats.dart';
import '../../data/models/hlr_stats.dart';

/// The Unified Result Bundle. 
/// It carries the state for ALL algorithms, regardless of which one was used.
class SrsUpdateResult {
  /// The primary "Due Date" calculated by the active algorithm.
  final DateTime nextReviewDate;
  
  /// The updated SM-2 stats (if processed).
  final Sm2Stats sm2Stats;
  
  /// The updated HLR stats (if processed).
  final HlrStats? hlrStats;

  const SrsUpdateResult({
    required this.nextReviewDate,
    required this.sm2Stats,
    this.hlrStats,
  });
}

/// The Contract.
/// Any future algorithm (FSRS, Ebisu, etc.) must implement this.
abstract class SrsAlgorithm {
  SrsUpdateResult calculateProgress({
    required Sm2Stats currentSm2,
    required HlrStats? currentHlr,
    required int grade, // 1 (Forgot) -> 4 (Easy)
  });
}
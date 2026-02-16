/// Holds calculated realtime statistics for the user dashboard.
///
/// It is calculated on the fly and not stored anywhere longtime.
class DashboardStats {
/// TODO: MAKE A SYSTEM FOR THIS
  final int currentStreak;
  final int totalVerses;
  
  /// Verses with retention > 90% (or HLR stability > 30 days).
  final int masteredVerses;
  
  final int totalReviews;
  
  /// Average retention rate (0.0 to 1.0) across all active verses.
  final double globalRetention;

  const DashboardStats({
    required this.currentStreak,
    required this.totalVerses,
    required this.masteredVerses,
    required this.totalReviews,
    required this.globalRetention,
  });

  factory DashboardStats.empty() {
    return const DashboardStats(
      currentStreak: 0,
      totalVerses: 0,
      masteredVerses: 0,
      totalReviews: 0,
      globalRetention: 0.0,
    );
  }
}
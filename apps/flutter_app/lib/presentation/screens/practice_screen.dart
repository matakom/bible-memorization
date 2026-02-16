// import 'package:flutter/material.dart';
// import 'package:flutter_app/data/repositories/stats_repository.dart';
// import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_app/data/models/saved_verse.dart';
// import 'package:flutter_app/presentation/screens/practice/flashcard_practice_screen.dart';

// class PracticeScreen extends ConsumerWidget {
//   const PracticeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final versesState = ref.watch(savedVersesControllerProvider);
//     ref.read(myStatsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Practice Center'),
//       ),
//       body: versesState.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Center(child: Text('Error: $err')),
//         data: (allVerses) {
//           // Find verses due for review
//           // Check if nextReviewDate is today or in the past
//           final now = DateTime.now();
//           final dueVerses = allVerses.where((v) {
//             if (v.nextReviewDate == null) return true; // Review immediately if null
//             // Compare dates only (ignore time)
//             final reviewDate = DateUtils.dateOnly(v.nextReviewDate!);
//             final today = DateUtils.dateOnly(now);
//             return !reviewDate.isAfter(today); 
//           }).toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- SECTION 1: DAILY DASHBOARD ---
//                 _DailyStatusCard(
//                   dueCount: dueVerses.length,
//                   totalCount: allVerses.length,
//                   onStart: () {
//                     if (dueVerses.isNotEmpty) {
//                       _launchFlashcards(context, dueVerses);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("You're all caught up! Great job!")),
//                       );
//                     }
//                   },
//                 ),
                
//                 const SizedBox(height: 32),
//                 Text(
//                   "Study Modes",
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),

//                 // --- SECTION 2: GAME MODES ---
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   children: [
//                     _GameCard(
//                       title: "Flashcards",
//                       icon: Icons.style,
//                       color: Colors.blue,
//                       // Option to practice ALL verses even if not due
//                       onTap: () => _launchFlashcards(context, allVerses), 
//                       description: "Classic flip cards",
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _launchFlashcards(BuildContext context, List<SavedVerse> verses) {
//     if (verses.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No verses available to practice.")),
//       );
//       return;
//     }
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => FlashcardPracticeScreen(versesToPractice: verses),
//       ),
//     );
//   }
// }

// // --- WIDGETS ---
// class _DailyStatusCard extends StatelessWidget {
//   final int dueCount;
//   final int totalCount;
//   final VoidCallback onStart;

//   const _DailyStatusCard({
//     required this.dueCount,
//     required this.totalCount,
//     required this.onStart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isAllDone = dueCount == 0;

//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isAllDone 
//               ? [Colors.green.shade400, Colors.green.shade700]
//               : [theme.colorScheme.primary, theme.colorScheme.tertiary],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: (isAllDone ? Colors.green : theme.colorScheme.primary).withValues(alpha: 0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             isAllDone ? "All Caught Up!" : "Ready to Review",
//             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             isAllDone 
//                 ? "You have reviewed all $totalCount verses." 
//                 : "You have $dueCount verses scheduled for today.",
//             style: const TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: onStart,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: isAllDone ? Colors.green.shade700 : theme.colorScheme.primary,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               icon: Icon(isAllDone ? Icons.check : Icons.play_arrow_rounded),
//               label: Text(
//                 isAllDone ? "Practice Anyway" : "Start Session",
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GameCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _GameCard({
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, size: 32, color: color),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
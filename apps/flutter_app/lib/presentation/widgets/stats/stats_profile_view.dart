// import 'package:flutter/material.dart';
// import 'package:flutter_app/data/models/dashboard_stats.dart';

// class StatsProfileView extends StatelessWidget {
//   final UserStats stats;

//   const StatsProfileView({super.key, required this.stats});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           _StatsHeader(
//             name: stats.fullName,
//             streak: stats.streak,
//           ),
          
//           const SizedBox(height: 32),

//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.3,
//             children: [
//               _StatCard(
//                 label: 'Saved Verses',
//                 value: stats.totalVerses.toString(),
//                 icon: Icons.bookmark_border,
//                 color: Colors.blue,
//               ),
//               _StatCard(
//                 label: 'Mastered',
//                 value: stats.masteredVerses.toString(),
//                 icon: Icons.school_outlined,
//                 color: Colors.purple,
//               ),
//               _StatCard(
//                 label: 'Total Reviews',
//                 value: stats.totalReviews.toString(),
//                 icon: Icons.history,
//                 color: Colors.orange,
//               ),
//               _StatCard(
//                 label: 'Accuracy',
//                 value: '${stats.averageAccuracy}%',
//                 icon: Icons.pie_chart_outline,
//                 color: Colors.green,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatsHeader extends StatelessWidget {
//   final String name;
//   final int streak;

//   const _StatsHeader({required this.name, required this.streak});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: theme.colorScheme.primaryContainer,
//           child: Text(
//             name.isNotEmpty ? name[0].toUpperCase() : '?',
//             style: TextStyle(fontSize: 40, color: theme.colorScheme.onPrimaryContainer),
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         // Name
//         Text(
//           name,
//           style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
//         ),
        
//         const SizedBox(height: 8),
        
//         // STREAK BADGE
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.orange.shade50,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.orange.shade200),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 24),
//               const SizedBox(width: 8),
//               Text(
//                 '$streak Day Streak',
//                 style: const TextStyle(
//                   color: Colors.deepOrange,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 32, color: color),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
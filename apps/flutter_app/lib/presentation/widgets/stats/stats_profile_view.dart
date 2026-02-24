import 'package:flutter/material.dart';
import 'package:flutter_app/data/models/user_stats.dart';

class StatsProfileView extends StatelessWidget {
  final UserStats stats;

  const StatsProfileView({super.key, required this.stats});

  // Helper function to convert seconds into readable text
  String _formatTime(int totalSeconds) {
    if (totalSeconds < 60) return '${totalSeconds}s';
    final minutes = totalSeconds ~/ 60;
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _StatsHeader(
            name: "Matěj Komárek",
          ),
          
          const SizedBox(height: 32),

          // 1st Row: Score (Width 2)
          SizedBox(
            width: double.infinity,
            child: _StatCard(
              label: 'Skóre',
              value: stats.score.toString(),
              icon: Icons.emoji_events,
              color: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            ),
          ),

          const SizedBox(height: 16),

          // 2nd Row: Streak and Memorized Verses
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Denní řada',
                  value: stats.streak.toString(),
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  label: 'Zapamatováno',
                  value: stats.memorizedVerses.toString(),
                  icon: Icons.school_outlined,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3rd Row: Time Spent and Total Practices
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Čas strávený učením',
                  value: _formatTime(stats.timeSpentSeconds),
                  icon: Icons.timer_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  label: 'Procvičení',
                  value: stats.totalPractices.toString(),
                  icon: Icons.repeat,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final String name;

  const _StatsHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(fontSize: 40, color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        const SizedBox(height: 16),
        
        // Name
        Text(
          name,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final EdgeInsetsGeometry padding;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
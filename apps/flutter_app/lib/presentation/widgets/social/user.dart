import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class User extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String status; // 'pending', 'accepted',
  final String direction; // 'sent', 'received'
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete;

  const User({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.direction,
    this.onTap,
    this.onAccept,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isClickable = status == 'accepted';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        // Only make the widget clickable if the friend is accepted
        onTap: isClickable ? onTap : null,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // User avatar (circle)
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '${firstName[0]}${lastName[0]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // User name
              Expanded(
                child: Text(
                  '$firstName $lastName',
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Trailing action widget
              _buildTrailingWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the trailing widget based on the friendship status and direction.
  Widget _buildTrailingWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (status == 'pending' && direction == 'received') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accept Button
          FilledButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check),
            label: Text(context.l10n.social_accept),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
          ),
          const SizedBox(width: 8.0),
          // Delete Button
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.close, color: colorScheme.error),
          ),
        ],
      );
    }

    if (status == 'pending' && direction == 'sent') {
      // Sent request: Show 'Pending' status
      return Text(
        context.l10n.social_pending,
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
      );
    }

    if (status == 'accepted') {
      // Accepted friend: Show chevron to indicate clickability
      return Icon(Icons.chevron_right, color: Colors.grey[600]);
    }

    // Default case (shouldn't happen)
    return const SizedBox.shrink();
  }
}
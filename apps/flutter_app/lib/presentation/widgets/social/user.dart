import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

/// A card representing a user/friend with status indicators and action buttons (Accept/Delete).
class User extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String status;
  final String direction;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete;

  const User({super.key, required this.firstName, required this.lastName, required this.status, required this.direction, this.onTap, this.onAccept, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final bool isClickable = status == 'accepted';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        onTap: isClickable ? onTap : null,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text('${firstName[0]}${lastName[0]}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ),
              const SizedBox(width: 16.0),
              Expanded(child: Text('$firstName $lastName', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
              _buildTrailingWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (status == 'pending' && direction == 'received') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check),
            label: Text(context.l10n.social_accept),
            style: FilledButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, padding: const EdgeInsets.symmetric(horizontal: 12.0)),
          ),
          const SizedBox(width: 8.0),
          IconButton(onPressed: onDelete, icon: Icon(Icons.close, color: colorScheme.error)),
        ],
      );
    }

    if (status == 'pending' && direction == 'sent') {
      return Text(context.l10n.social_pending, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]));
    }

    return status == 'accepted' ? Icon(Icons.chevron_right, color: Colors.grey[600]) : const SizedBox.shrink();
  }
}
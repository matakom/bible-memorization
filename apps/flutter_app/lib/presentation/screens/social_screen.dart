// import 'package:flutter/material.dart';
// import 'package:flutter_app/l10n/l10n_extension.dart';
// import 'package:flutter_app/presentation/widgets/social/add_friend_button.dart';
// import 'package:flutter_app/presentation/widgets/social/add_friend_modal_content.dart';
// import 'package:flutter_app/presentation/widgets/social/friends_list_widget.dart';
// import 'package:flutter_app/presentation/widgets/social/user_code.dart';
// import 'package:flutter_app/providers/friendships/friendships_provider.dart';
// import 'package:flutter_app/providers/user_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SocialScreen extends ConsumerWidget {
//   const SocialScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncFriendships = ref.watch(friendshipsProvider);
//     final asyncUser = ref.watch(userDataProvider);

//     return Scaffold(
//       appBar: AppBar(title: Text(context.l10n.social_screenTitle)),
//       body: asyncUser.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error loading user: $err')),
//         data: (user) {
//           if (user == null) {
//             return const Center(child: Text('Error: User not logged in.'));
//           }
          
//           if (user.friendCode == 'OFFLINE') {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(32.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.cloud_off, size: 64, color: Colors.grey),
//                     const SizedBox(height: 16),
//                     Text(
//                       "Social features unavailable offline",
//                       style: Theme.of(context).textTheme.titleLarge,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Please connect to the internet and restart the app to sync your friend code.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           final currentUserId = user.id;

//           return asyncFriendships.when(
//             data: (friendships) {
//               return Column(
//                 children: [
//                   const UserCode(),
//                   AddFriendButton(
//                     onPressed: () => _showAddFriendModal(context),
//                   ),
//                   FriendsListWidget(
//                     friendships: friendships,
//                     currentUserId: currentUserId,
//                   ),
//                 ],
//               );
//             },
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (err, stack) => Center(
//               child: Text(
//                 'Error loading friendships: $err',
//                 style: TextStyle(color: Theme.of(context).colorScheme.error),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showAddFriendModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext modalContext) {
//         return const AddFriendModalContent();
//       },
//     );
//   }
// }
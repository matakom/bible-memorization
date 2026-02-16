// import 'package:drift_db_viewer/drift_db_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/data/local/app_database.dart' as db;
// import 'package:flutter_app/providers/auth_controller.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '/l10n/l10n_extension.dart'; // Keep your existing imports
// import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';
// import 'package:flutter_app/providers/settings/settings_loading_provider.dart';

// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.listen<AsyncValue>(authControllerProvider, (_, state) {
//       if (state.hasError && !state.isLoading) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               state.error.toString().replaceAll('Exception: ', ''),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.error,
//           ),
//         );
//       }
//     });

//     final isLoading = ref.watch(settingsLoadingProvider);

//     return Scaffold(
//       appBar: AppBar(title: Text(context.l10n.login_screenTitle)),
//       body: Center(
//         child: Column(
//           children: [
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : const SignInButton(),
//             ElevatedButton(
//               child: const Text("Debug DB"),
//               onPressed: () {
//                 final database = ref.read(db.databaseProvider);

//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => DriftDbViewer(database),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
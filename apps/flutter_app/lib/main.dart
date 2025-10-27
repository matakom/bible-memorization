import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/data/api/api_service.dart';

// --- GetIt Setup ---
// Create the global service locator instance
final sl = GetIt.instance;

void setupLocator() {
  // Register Dio (the HTTP client) as a "lazy singleton".
  // It will only be created once, the first time it's needed.
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register your ApiService. GetIt is smart and will automatically
  // find and pass the Dio instance it just created.
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));
}
// --- End Setup ---


void main() {
  // 1. Set up all our services *before* the app runs
  setupLocator();

  // 2. Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Health Check Example',
      home: HealthCheckScreen(),
    );
  }
}

// This is a simple screen that calls the health check on startup
class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  String _healthStatus = "Checking server health...";

  @override
  void initState() {
    super.initState();
    _performHealthCheck(); // Call the check when the screen loads
  }

  void _performHealthCheck() async {
    // 3. Get the ApiService instance from GetIt
    final apiService = sl<ApiService>();

    // 4. Call the method
    final bool isHealthy = await apiService.checkHealth();

    // 5. Update the UI
    // (We check 'mounted' to ensure the widget is still visible)
    if (mounted) {
      setState(() {
        _healthStatus = isHealthy ? "Server is Healthy! ✅" : "Server is Down! ❌";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _healthStatus,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performHealthCheck,
              child: const Text("Check Again"),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/task_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  await Supabase.initialize(
    url: SupabaseConfig.url,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(AuthRepository(supabaseClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskNotifier(TaskRepository(supabaseClient)),
        ),
      ],
      child: MaterialApp(
        title: 'Task Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    if (authNotifier.isAuthenticated) {
      return const HomeScreen();
    }
    return const AuthScreen();
  }
}

import 'package:flutter/material.dart';
import 'package:techpluse/screens/auth/onborading_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techpluse/theme/app_theme.dart';
import 'package:techpluse/screens/main_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "api_keys.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_API_KEY']!,
  );

  runApp(const MyWidget());
}


class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: AuthGate(),
    );
  }
}



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        if (session != null) {
          return const MainLayout();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}


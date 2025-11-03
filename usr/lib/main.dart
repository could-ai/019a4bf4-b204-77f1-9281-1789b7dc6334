import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/food_analysis_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Inicializar Supabase quando conectado
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness Personalizado com IA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',  // Suporte a português
        ),
        home: const InitialScreen(),
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/food_analysis': (context) => const FoodAnalysisScreen(),
          // TODO: Adicionar rotas para treinos e progresso quando implementadas
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // Verificar se usuário já completou onboarding
    if (!userProvider.isOnboardingComplete) {
      return const OnboardingScreen();
    }
    return const DashboardScreen();
  }
}
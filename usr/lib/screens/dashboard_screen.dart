import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'workout_screen.dart';
import 'progress_screen.dart';
import 'food_analysis_screen.dart';
import 'diet_screen.dart'; // Import para a tela de dieta

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final workout = userProvider.currentWorkout;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Olá! Seu treino personalizado está pronto.', style: Theme.of(context).textTheme.headlineSmall),
            if (workout != null) ...[
              Card(
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text('${workout.exercises.length} exercícios'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutScreen(workout: workout)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressScreen()),
              ),
              child: const Text('Ver Progresso'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FoodAnalysisScreen()),
              ),
              child: const Text('Analisar Alimento'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/diet'),
              child: const Text('Ver Plano de Dieta'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treinos'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Progresso'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrição'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Dieta'),
        ],
        onTap: (index) {
          if (index == 0) return; // já está na dashboard
          if (index == 1 && userProvider.currentWorkout != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WorkoutScreen(workout: userProvider.currentWorkout!)),
            );
          }
          if (index == 2) Navigator.pushNamed(context, '/progress');
          if (index == 3) Navigator.pushNamed(context, '/food_analysis');
          if (index == 4) Navigator.pushNamed(context, '/diet');
        },
      ),
    );
  }
}

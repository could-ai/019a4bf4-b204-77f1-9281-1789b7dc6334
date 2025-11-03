import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'workout_screen.dart';
import 'progress_screen.dart';

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
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressScreen()),
              ),
              child: const Text('Ver Progresso'),
            ),
            // TODO: Adicionar seção para wearables e monetização
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treinos'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Progresso'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/workout');
          if (index == 2) Navigator.pushNamed(context, '/progress');
        },
      ),
    );
  }
}
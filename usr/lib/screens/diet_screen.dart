import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dietPlan = Provider.of<UserProvider>(context).dietPlan;

    return Scaffold(
      appBar: AppBar(title: const Text('Plano de Dieta Semanal')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dietPlan.length,
        itemBuilder: (context, index) {
          final dayPlan = dietPlan[index];
          return ExpansionTile(
            title: Text(dayPlan.day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: dayPlan.meals.map((meal) {
              return ListTile(
                title: Text(meal.name),
                subtitle: Text(
                  '${meal.calories.toStringAsFixed(0)} kcal\nItens: ${meal.items.join(', ')}',
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

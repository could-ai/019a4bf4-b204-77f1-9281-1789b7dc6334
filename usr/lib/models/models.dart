import 'package:flutter/foundation.dart';

class User {
  String? goal;  // Ex: 'perder_peso', 'ganhar_massa', 'melhorar_resistencia'
  String? fitnessLevel;  // 'iniciante', 'intermediario', 'avancado'
  List<String>? equipment;  // Lista de equipamentos disponíveis
  bool? smallSpace;  // True se treino em espaço pequeno (apartamento)
  Map<String, dynamic>? restrictions;  // Restrições físicas

  User({
    this.goal,
    this.fitnessLevel,
    this.equipment,
    this.smallSpace,
    this.restrictions,
  });

  Map<String, dynamic> toJson() => {
    'goal': goal,
    'fitnessLevel': fitnessLevel,
    'equipment': equipment,
    'smallSpace': smallSpace,
    'restrictions': restrictions,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    goal: json['goal'],
    fitnessLevel: json['fitnessLevel'],
    equipment: json['equipment']?.cast<String>(),
    smallSpace: json['smallSpace'],
    restrictions: json['restrictions'],
  );
}

class Workout {
  String id;
  String name;
  List<Exercise> exercises;

  Workout({required this.id, required this.name, required this.exercises});

  // TODO: Adicionar método para gerar treinos baseados em dados do usuário (simulação de IA)
}

class Exercise {
  String name;
  int sets;
  int reps;
  String? description;
  bool? requiresCamera;  // Para correção de forma

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.description,
    this.requiresCamera,
  });
}

class Progress {
  DateTime date;
  double weight;
  Map<String, double>? measurements;  // Ex: peito, braço

  Progress({required this.date, required this.weight, this.measurements});
}
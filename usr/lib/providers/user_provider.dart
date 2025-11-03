import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isOnboardingComplete = false;
  List<Progress> _progress = [];
  Workout? _currentWorkout;  // Treino atual (simulado)

  User? get user => _user;
  bool get isOnboardingComplete => _isOnboardingComplete;
  List<Progress> get progress => _progress;
  Workout? get currentWorkout => _currentWorkout;

  void setUser(User user) {
    _user = user;
    _isOnboardingComplete = true;
    _generateWorkout();  // Simulação de IA: gerar treino baseado em dados
    _saveToPrefs();
    notifyListeners();
  }

  void addProgress(Progress newProgress) {
    _progress.add(newProgress);
    _saveToPrefs();
    notifyListeners();
  }

  void _generateWorkout() {
    // Simulação de IA: treino básico baseado em dados do usuário
    List<Exercise> exercises = [];
    if (_user?.smallSpace == true) {
      exercises.add(Exercise(name: 'Agachamento sem equipamento', sets: 3, reps: 10, description: 'Exercício para espaços pequenos.'));
      exercises.add(Exercise(name: 'Prancha', sets: 3, reps: 30, requiresCamera: true));
    } else {
      exercises.add(Exercise(name: 'Supino com halteres', sets: 3, reps: 12));
    }
    _currentWorkout = Workout(id: '1', name: 'Treino Personalizado', exercises: exercises);
    // TODO: Integrar com IA real via Supabase Edge Function
  }

  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', _user?.toJson().toString() ?? '');
    // TODO: Salvar progresso e treinos
  }

  void loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null && userJson.isNotEmpty) {
      // TODO: Desserializar e carregar dados
      _isOnboardingComplete = true;
      notifyListeners();
    }
  }
}
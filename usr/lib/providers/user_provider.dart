import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isOnboardingComplete = false;
  List<Progress> _progress = [];
  Workout? _currentWorkout;  // Treino atual (simulado)
  List<FoodItem> _analyzedFoods = [];  // Lista de alimentos analisados

  User? get user => _user;
  bool get isOnboardingComplete => _isOnboardingComplete;
  List<Progress> get progress => _progress;
  Workout? get currentWorkout => _currentWorkout;
  List<FoodItem> get analyzedFoods => _analyzedFoods;

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

  void addAnalyzedFood(FoodItem food) {
    _analyzedFoods.add(food);
    _saveToPrefs();
    notifyListeners();
  }

  Future<String?> analyzeFoodImage(XFile? image) async {
    if (image == null) return null;
    // Simulação de análise com Google ML Kit
    final inputImage = InputImage.fromFilePath(image.path);
    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    await imageLabeler.close();
    // Simulação: mapear labels para alimentos e calorias
    if (labels.isNotEmpty) {
      final label = labels.first;
      String foodName = label.label;
      double calories = _estimateCalories(foodName);
      FoodItem food = FoodItem(name: foodName, calories: calories, date: DateTime.now());
      addAnalyzedFood(food);
      return '$foodName: aproximadamente ${calories.toStringAsFixed(0)} calorias';
    }
    return 'Não foi possível identificar o alimento. Tente uma foto mais clara.';
  }

  double _estimateCalories(String label) {
    // Simulação simples de estimativa de calorias baseada em label
    switch (label.toLowerCase()) {
      case 'apple':
        return 95.0;
      case 'banana':
        return 105.0;
      case 'rice':
        return 200.0;
      default:
        return 150.0;  // Estimativa padrão
    }
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
    // TODO: Salvar progresso, treinos e alimentos analisados
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
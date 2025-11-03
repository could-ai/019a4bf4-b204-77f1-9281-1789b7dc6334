import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../models/models.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isOnboardingComplete = false;
  List<Progress> _progress = [];
  Workout? _currentWorkout;
  List<FoodItem> _analyzedFoods = [];
  List<DietDayPlan> _dietPlan = []; // Plano de dieta semanal

  User? get user => _user;
  bool get isOnboardingComplete => _isOnboardingComplete;
  List<Progress> get progress => _progress;
  Workout? get currentWorkout => _currentWorkout;
  List<FoodItem> get analyzedFoods => _analyzedFoods;
  List<DietDayPlan> get dietPlan => _dietPlan; // Getter para acesso ao plano de dieta

  void setUser(User user) {
    _user = user;
    _isOnboardingComplete = true;
    _generateWorkout(); // Gera treino baseado em IA simulada
    _generateDiet();    // Gera plano de dieta semanal básico
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
    final inputImage = InputImage.fromFilePath(image.path);
    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    await imageLabeler.close();
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
    switch (label.toLowerCase()) {
      case 'apple':
        return 95.0;
      case 'banana':
        return 105.0;
      case 'rice':
        return 200.0;
      default:
        return 150.0;
    }
  }

  void _generateWorkout() {
    List<Exercise> exercises = [];
    if (_user?.smallSpace == true) {
      exercises.add(Exercise(name: 'Agachamento sem equipamento', sets: 3, reps: 10, description: 'Para espaços pequenos'));
      exercises.add(Exercise(name: 'Prancha', sets: 3, reps: 30, requiresCamera: true));
      exercises.add(Exercise(name: 'Afundos', sets: 3, reps: 12, description: 'Exercício de perna simples'));
    } else {
      exercises.add(Exercise(name: 'Supino com halteres', sets: 3, reps: 12));
      exercises.add(Exercise(name: 'Remada curvada', sets: 3, reps: 10));
      exercises.add(Exercise(name: 'Agachamento com barra', sets: 4, reps: 8));
    }
    _currentWorkout = Workout(id: '1', name: 'Treino Personalizado', exercises: exercises);
  }

  // Gera plano de dieta semanal básico para o usuário
  void _generateDiet() {
    final days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    _dietPlan = days.map((day) {
      List<Meal> meals = [];
      meals.add(Meal(
        name: 'Café da manhã',
        items: ['2 ovos cozidos', '1 fatia de pão integral'],
        calories: 350,
      ));
      meals.add(Meal(
        name: 'Almoço',
        items: ['150g de frango grelhado', 'Salada verde', 'Arroz integral'],
        calories: 600,
      ));
      meals.add(Meal(
        name: 'Lanche da tarde',
        items: ['1 maçã', '1 punhado de amêndoas'],
        calories: 200,
      ));
      meals.add(Meal(
        name: 'Jantar',
        items: ['Omelete de vegetais'],
        calories: 400,
      ));
      return DietDayPlan(day: day, meals: meals);
    }).toList();
  }

  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', _user?.toJson().toString() ?? '');
    // TODO: salvar progresso, treinos, alimentos e dieta planejada
  }

  void loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null && userJson.isNotEmpty) {
      _isOnboardingComplete = true;
      notifyListeners();
    }
  }
}

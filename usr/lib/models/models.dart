class User {
  String? goal;
  String? fitnessLevel;
  bool smallSpace;
  List<String> equipment;

  User({
    this.goal,
    this.fitnessLevel,
    this.smallSpace = false,
    this.equipment = const [],
  });

  Map<String, dynamic> toJson() => {
    'goal': goal,
    'fitnessLevel': fitnessLevel,
    'smallSpace': smallSpace,
    'equipment': equipment,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    goal: json['goal'],
    fitnessLevel: json['fitnessLevel'],
    smallSpace: json['smallSpace'] ?? false,
    equipment: List<String>.from(json['equipment'] ?? []),
  );
}

class Progress {
  DateTime date;
  double weight;

  Progress({required this.date, required this.weight});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weight': weight,
  };

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    date: DateTime.parse(json['date']),
    weight: json['weight'],
  );
}

class Exercise {
  String name;
  int sets;
  int reps;
  String? description;
  bool? requiresCamera;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.description,
    this.requiresCamera,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets,
    'reps': reps,
    'description': description,
    'requiresCamera': requiresCamera,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    sets: json['sets'],
    reps: json['reps'],
    description: json['description'],
    requiresCamera: json['requiresCamera'],
  );
}

class Workout {
  String id;
  String name;
  List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'],
    name: json['name'],
    exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
  );
}

class FoodItem {
  String name;
  double calories;
  DateTime date;

  FoodItem({required this.name, required this.calories, required this.date});

  Map<String, dynamic> toJson() => {
    'name': name,
    'calories': calories,
    'date': date.toIso8601String(),
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    name: json['name'],
    calories: json['calories'],
    date: DateTime.parse(json['date']),
  );
}
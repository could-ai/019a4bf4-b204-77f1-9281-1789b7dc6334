import 'package:flutter/material.dart';

import '../models/models.dart';

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
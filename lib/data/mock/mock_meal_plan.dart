import 'package:flutter/material.dart';
import '../models/meal_plan_item.dart';

final mockMealPlan = [
  MealPlanItem(
    id: 'mp1',
    petName: 'Luna',
    meal: 'Morning kibble + warm water',
    time: const TimeOfDay(hour: 8, minute: 0),
    calories: 220,
    isDone: true,
    note: 'Add joint supplement.',
  ),
  MealPlanItem(
    id: 'mp2',
    petName: 'Milo',
    meal: 'Chicken & rice bowl',
    time: const TimeOfDay(hour: 13, minute: 0),
    calories: 320,
    isDone: false,
    note: 'Serve lukewarm for stomach comfort.',
  ),
  MealPlanItem(
    id: 'mp3',
    petName: 'Bella',
    meal: 'Light dinner kibble',
    time: const TimeOfDay(hour: 19, minute: 30),
    calories: 250,
    isDone: false,
    note: 'Mix with probiotic powder.',
  ),
];

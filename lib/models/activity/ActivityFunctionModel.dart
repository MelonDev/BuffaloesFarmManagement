import 'package:flutter/material.dart';

class ActivityFunctionModel {
  String name;
  IconData icon;
  VoidCallback? function;

  ActivityFunctionModel(
      {required this.name, required this.icon, this.function});
}

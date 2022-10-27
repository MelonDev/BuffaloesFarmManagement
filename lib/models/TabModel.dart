import 'package:flutter/material.dart';

class TabModel {
  String name;
  IconData icon;
  Widget body;
  Color color;
  Function? onTap;
  String? tag;
  IconData? activeIcon;

  TabModel(
      {required this.name,
        required this.icon,
        required this.body,
        required this.color,
        this.tag,
        this.activeIcon,
        this.onTap});
}

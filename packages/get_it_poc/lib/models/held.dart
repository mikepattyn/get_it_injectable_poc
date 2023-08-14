import 'package:flutter/material.dart';
import 'package:shared/models/weapon.dart';

abstract class Held extends ChangeNotifier {
  int get health;
  Weapon get weapon;

  void attack();
}

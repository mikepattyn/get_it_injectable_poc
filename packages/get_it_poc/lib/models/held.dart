import 'package:flutter/material.dart';
import 'package:get_it_poc/models/weapon.dart';

abstract class Held extends ChangeNotifier {
  int get health;
  Weapon get weapon;

  void attack();
}

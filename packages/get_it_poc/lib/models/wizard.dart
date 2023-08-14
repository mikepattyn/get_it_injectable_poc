import 'package:get_it_poc/models/held.dart';
import 'package:get_it_poc/models/magicstaff.dart';
import 'package:get_it_poc/models/weapon.dart';
import 'package:injectable/injectable.dart';

@singleton
class Wizard extends Held {
  int _health = 100;
  MagicStaff _weapon;

  Wizard(this._weapon);

  @override
  void attack() {
    _health = _health - _weapon.power;
    notifyListeners();
  }

  @override
  Weapon get weapon => _weapon;

  @override
  int get health => _health;
}

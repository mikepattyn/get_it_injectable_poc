import './weapon.dart';
import 'package:injectable/injectable.dart';

@injectable
class MagicStaff extends Weapon {
  @override
  int get power => 1;
}

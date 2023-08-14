import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'getit.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void setupDependencies() => getIt.init();

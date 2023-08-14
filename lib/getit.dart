import 'package:get_it/get_it.dart';
import 'package:get_it_poc/get_it_poc.module.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.module.dart';
import 'getit.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  // This way we can control the order in which dependencies are loaded.
  // We can have multiple feature modules depending on a shared module
  externalPackageModules: [
    SharedPackageModule,
    GetItPocPackageModule,
  ],
)
void setupDependencies() => getIt.init();

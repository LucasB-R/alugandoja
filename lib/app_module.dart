import 'package:flutter_modular/flutter_modular.dart';
import 'package:alugandoja/modules/calculate/di/calculate_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CalculateModule(),
      ];

  @override
  final List<Bind> binds = [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: CalculateModule()),
      ];
}

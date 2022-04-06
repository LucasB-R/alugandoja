import 'package:alugandoja/modules/calculate/presenter/bloc/calculate_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/calculate_usecase.dart';
import 'package:alugandoja/modules/calculate/infra/repositories/calculation_repository.dart';
import 'package:alugandoja/modules/calculate/internal/calculation.dart';
import 'package:alugandoja/modules/calculate/presenter/calculate_page.dart';

class CalculateModule extends Module {
  @override
  List<Module> get imports => [];

  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => CalculateUsecase(i())),
        Bind.lazySingleton((i) => CalculationRepository(i())),
        Bind.lazySingleton((i) => Calculation()),
        Bind.lazySingleton((i) => CalculateBloc(i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CalculatePage()),
  ];
}

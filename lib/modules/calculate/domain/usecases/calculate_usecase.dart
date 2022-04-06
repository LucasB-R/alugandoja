import 'package:dartz/dartz.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/errors/errors.dart';
import 'package:alugandoja/modules/calculate/domain/repositories/interfaces/calculation_repository_interface.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/interfaces/calculate_interface.dart';

class CalculateUsecase implements CalculateInterface {
  final CalculationRepositoryInterface repository;

  CalculateUsecase(this.repository);

  @override
  Future<Either<CalculationException, CalculationResult>> call(
      CalculationParams params) async {
    return await repository.calculate(params);
  }
}

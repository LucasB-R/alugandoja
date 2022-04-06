import 'package:dartz/dartz.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/errors/errors.dart';

abstract class CalculateInterface {
  Future<Either<CalculationException, CalculationResult>> call(
      CalculationParams params);
}

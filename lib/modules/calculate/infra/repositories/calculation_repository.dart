import 'package:alugandoja/modules/calculate/domain/errors/errors.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:dartz/dartz.dart';
import 'package:alugandoja/modules/calculate/infra/datasource/calculation_datasource.dart';
import 'package:alugandoja/modules/calculate/domain/repositories/interfaces/calculation_repository_interface.dart';

class CalculationRepository implements CalculationRepositoryInterface {
  final CalculationDatasource calculationDatasource;

  CalculationRepository(this.calculationDatasource);

  @override
  Future<Either<CalculationException, CalculationResult>> calculate(
      CalculationParams params) async {
    try {
      CalculationResult calculationResult =
          await calculationDatasource.calculate(params);

      return Right(calculationResult);
    } catch (e) {
      return Left(CalculationError());
    }
  }
}

import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';

abstract class CalculationDatasource {
  Future<CalculationResult> calculate(CalculationParams params);
}

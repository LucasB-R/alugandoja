import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';

abstract class CalculateStates {}

class CalculationStart extends CalculateStates {}

class Calculating extends CalculateStates {}

class CalculateResult extends CalculateStates {
  final CalculationResult result;

  CalculateResult(this.result);
}

class CalculateError extends CalculateStates {}

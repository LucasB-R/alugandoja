import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';

abstract class CalculateEvents {}

class Calculate extends CalculateEvents {
  final CalculationParams params;
  Calculate(this.params);
}

class ResetResult extends CalculateEvents {}

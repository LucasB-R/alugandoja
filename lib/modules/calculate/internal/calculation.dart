import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/infra/datasource/calculation_datasource.dart';
import 'package:alugandoja/utils/constants/regions_list_constants.dart';

class Calculation implements CalculationDatasource {
  @override
  Future<CalculationResult> calculate(CalculationParams params) async {
    //Params
    var residenceValue = params.residenceValue;
    var expectedValue = params.expectedValue;
    var bedroomsNumber = params.bedroomsNumber;
    var multiplier = residenceValue * bedroomsNumber / 1000;

    var selectedRegion = params.region;

    //Calculations
    var minValue = residenceValue * 0.005;
    var maxValue = residenceValue * 0.01;

    //Complements
    String phraseComplements = "";

    if (expectedValue != null) {
      if (expectedValue < minValue) {
        phraseComplements =
            "Pelos cálculos realizados, você facilmente consegue alugar seu imóvel pelo seu valor esperado.";
      }
      if (expectedValue > maxValue) {
        phraseComplements =
            "Pelos cálculos realizados, você dificilmente consegue alugar seu imóvel pelo seu valor esperado.";
      }
    }

    var containsInRegionList =
        RegionsList.regions.where((region) => region == selectedRegion);
    if (containsInRegionList.isEmpty) {
      throw Exception("Region not found");
    }

    //Region Data
    var regionLabel = _getRegionLabel(selectedRegion);
    var minRegionValue = _getMinRegionValue(selectedRegion, residenceValue);
    var maxRegionValue = _getMaxRegionValue(selectedRegion, residenceValue);

    String complementText =
        "Por se situar em uma região de classe $regionLabel, recomenda-se alugar entre R\$ ${(minRegionValue + multiplier).toStringAsFixed(2).replaceAll('.', ',')} e R\$ ${(maxRegionValue + multiplier).toStringAsFixed(2).replaceAll('.', ',')}. $phraseComplements";

    return CalculationResult(
        minValue: minValue + multiplier,
        maxValue: maxValue + multiplier,
        complementsText: complementText);
  }

  _getRegionLabel(selectedRegion) {
    if (selectedRegion == 1) {
      return "Classe Alta";
    }

    if (selectedRegion == 2) {
      return "Classe Média";
    }

    if (selectedRegion == 3) {
      return "Classe Baixa";
    }
  }

  _getMinRegionValue(selectedRegion, residenceValue) {
    if (selectedRegion == 3) {
      return residenceValue * 0.005;
    }

    if (selectedRegion == 2) {
      return residenceValue * 0.006;
    }

    if (selectedRegion == 1) {
      return residenceValue * 0.007;
    }
  }

  _getMaxRegionValue(selectedRegion, residenceValue) {
    if (selectedRegion == 3) {
      return residenceValue * 0.006;
    }

    if (selectedRegion == 2) {
      return residenceValue * 0.008;
    }

    if (selectedRegion == 1) {
      return residenceValue * 0.01;
    }
  }
}

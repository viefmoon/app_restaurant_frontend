import 'package:app/src/domain/useCases/areas/GetAreasUseCase.dart';
import 'package:app/src/domain/useCases/areas/GetTablesFromAreaUseCase.dart';

class AreasUseCases {
  GetAreasUseCase getAreas;
  GetTablesFromAreaUseCase getTablesFromArea;

  AreasUseCases({
    required this.getAreas,
    required this.getTablesFromArea,
  });
}

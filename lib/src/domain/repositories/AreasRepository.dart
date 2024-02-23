import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart';
import 'package:app/src/domain/utils/Resource.dart';

abstract class AreasRepository {
  Future<Resource<List<Area>>> getAreas();
  Future<Resource<List<Table>>> getTablesFromArea(int areaId);
}

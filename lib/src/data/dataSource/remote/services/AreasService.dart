import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/models/Area.dart'; // Asegúrate de tener un modelo Area
import 'package:app/src/domain/models/Table.dart'; // Asegúrate de tener un modelo Table
import 'package:app/src/domain/utils/Resource.dart';

class AreasService {
  Future<Resource<List<Area>>> getAreas() async {
    try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/areas');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Area> areas =
            data.map((dynamic item) => Area.fromJson(item)).toList();
        return Success(areas);
      } else {
        return Error("Error al recuperar las áreas: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<List<Table>>> getTablesFromArea(int areaId) async {
    try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, 'areas/$areaId/tables');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Table> tables =
            data.map((dynamic item) => Table.fromJson(item)).toList();
        return Success(tables);
      } else {
        return Error("Error al recuperar las mesas: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }
}

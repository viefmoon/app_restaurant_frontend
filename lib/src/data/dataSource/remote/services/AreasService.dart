import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/models/Area.dart'; // Asegúrate de tener un modelo Area
import 'package:app/src/domain/models/Table.dart'; // Asegúrate de tener un modelo Table
import 'package:app/src/domain/utils/Resource.dart';

class AreasService {
  Future<Resource<List<Area>>> getAreas() async {
    try {
      print('Cargando areas locoococco.');
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/areas');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Area> areas =
            data.map((dynamic item) => Area.fromJson(item)).toList();
        print('Areas: $areas');
        return Success(areas);
      } else {
        print('Error al recuperar las áreas: ${response.body}');
        return Error("Error al recuperar las áreas: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<List<Table>>> getTablesFromArea(int areaId) async {
    try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, 'areas/$areaId/tables');
      final response = await http.get(url);
      print('Response.body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Table> tables =
            data.map((dynamic item) => Table.fromJson(item)).toList();
        print('Tables: $tables');
        return Success(tables);
      } else {
        print('Error al recuperar las mesas: ${response.body}');
        return Error("Error al recuperar las mesas: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}

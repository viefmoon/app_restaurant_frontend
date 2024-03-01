import 'dart:convert';
import 'package:app/src/domain/models/Category.dart';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/utils/Resource.dart';

class CategoriesService {
  Future<Resource<List<Category>>> getCategoriesWithProducts() async {
    try {
      print('Cargando categories con productos');
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/categories');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('Data: $data');
        List<Category> categories =
            data.map((dynamic item) => Category.fromJson(item)).toList();
        print('Categories: $categories');
        return Success(categories);
      } else {
        print('Error al recuperar las áreas: ${response.body}');
        return Error("Error al recuperar las áreas: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}

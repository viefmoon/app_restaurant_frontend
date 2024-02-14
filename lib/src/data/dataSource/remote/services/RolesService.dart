import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/models/Role.dart';
import 'package:app/src/domain/utils/Resource.dart';

class RolesService {
  Future<Resource<List<Role>>> getRoles() async {
    try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/roles');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Role> roles =
            data.map((dynamic item) => Role.fromJson(item)).toList();
        print('Roles: $roles');
        return Success(roles);
      } else {
        return Error("Error al recuperar los roles: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}

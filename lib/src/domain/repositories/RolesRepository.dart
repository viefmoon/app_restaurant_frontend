import 'package:app/src/domain/models/Role.dart';
import 'package:app/src/domain/utils/Resource.dart';

abstract class RolesRepository {
  Future<Resource<List<Role>>> getRoles();
}

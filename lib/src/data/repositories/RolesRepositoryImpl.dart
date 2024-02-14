import 'package:app/src/data/dataSource/remote/services/RolesService.dart';
import 'package:app/src/domain/models/Role.dart';
import 'package:app/src/domain/repositories/RolesRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class RolesRepositoryImpl implements RolesRepository {
  RolesService rolesService;

  RolesRepositoryImpl(this.rolesService);

  @override
  Future<Resource<List<Role>>> getRoles() async {
    return rolesService.getRoles();
  }
}

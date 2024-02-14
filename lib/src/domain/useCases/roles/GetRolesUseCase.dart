import 'package:app/src/domain/repositories/RolesRepository.dart';

class GetRolesUseCase {
  RolesRepository rolesRepository;
  GetRolesUseCase(this.rolesRepository);

  run() => rolesRepository.getRoles();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/src/data/dataSource/local/SharedPref.dart' as _i15;
import 'package:app/src/data/dataSource/remote/services/AreasService.dart'
    as _i4;
import 'package:app/src/data/dataSource/remote/services/AuthService.dart'
    as _i7;
import 'package:app/src/data/dataSource/remote/services/CategoriesService.dart'
    as _i10;
import 'package:app/src/data/dataSource/remote/services/RolesService.dart'
    as _i13;
import 'package:app/src/data/dataSource/remote/services/UsersService.dart'
    as _i17;
import 'package:app/src/di/AppModule.dart' as _i19;
import 'package:app/src/domain/repositories/AreasRepository.dart' as _i3;
import 'package:app/src/domain/repositories/AuthRepository.dart' as _i6;
import 'package:app/src/domain/repositories/CategoriesRepository.dart' as _i9;
import 'package:app/src/domain/repositories/RolesRepository.dart' as _i12;
import 'package:app/src/domain/repositories/UsersRepository.dart' as _i16;
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart' as _i5;
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart' as _i8;
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart'
    as _i11;
import 'package:app/src/domain/useCases/roles/RolesUseCases.dart' as _i14;
import 'package:app/src/domain/useCases/users/UsersUseCases.dart' as _i18;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.AreasRepository>(() => appModule.areasRepository);
    gh.factory<_i4.AreasService>(() => appModule.areasService);
    gh.factory<_i5.AreasUseCases>(() => appModule.areasUseCases);
    gh.factory<_i6.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i7.AuthService>(() => appModule.authService);
    gh.factory<_i8.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i9.CategoriesRepository>(() => appModule.categoriesRepository);
    gh.factory<_i10.CategoriesService>(() => appModule.categoriesService);
    gh.factory<_i11.CategoriesUseCases>(() => appModule.categoriesUseCases);
    gh.factory<_i12.RolesRepository>(() => appModule.rolesRepository);
    gh.factory<_i13.RolesService>(() => appModule.rolesService);
    gh.factory<_i14.RolesUseCases>(() => appModule.rolesUseCases);
    gh.factory<_i15.SharedPref>(() => appModule.sharedPref);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i16.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i17.UsersService>(() => appModule.usersService);
    gh.factory<_i18.UsersUseCases>(() => appModule.usersUseCases);
    return this;
  }
}

class _$AppModule extends _i19.AppModule {}

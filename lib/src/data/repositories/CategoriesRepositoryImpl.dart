import 'package:app/src/data/dataSource/remote/services/CategoriesService.dart';
import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/repositories/CategoriesRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesService categoriesService;

  CategoriesRepositoryImpl(this.categoriesService);

  @override
  Future<Resource<List<Category>>> getCategoriesWithProducts() async {
    return categoriesService.getCategoriesWithProducts();
  }
}

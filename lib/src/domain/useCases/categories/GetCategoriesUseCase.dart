import 'package:ecommerce_flutter/src/domain/repositories/CategoriesRepository.dart';

class GetCategoriesUseCase {

  CategoriesRepository categoriesRepository;

  GetCategoriesUseCase(this.categoriesRepository);

  run() => categoriesRepository.getCategories();

}
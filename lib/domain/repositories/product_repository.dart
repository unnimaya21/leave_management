// lib/domain/repositories/product_repository.dart
import 'package:leave_management/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
}

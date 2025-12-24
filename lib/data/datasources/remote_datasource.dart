// lib/data/datasources/remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:leave_management/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://dummyjson.com/products');
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = response.data['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

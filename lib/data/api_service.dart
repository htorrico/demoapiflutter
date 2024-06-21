// lib/data/api_service.dart
import 'dart:convert';
import 'package:demoapi/model/product.dart';
import 'package:http/http.dart' as http;


class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));    
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Product> products = body.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
}

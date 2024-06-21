// lib/page/product_page.dart
import 'package:demoapi/data/api_service.dart';
import 'package:demoapi/model/product.dart';
import 'package:demoapi/page/add_product_page.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final ApiService apiService = ApiService(baseUrl: 'https://localhost:7187/api');
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.18.198:81/api');
  // final ApiService apiService = ApiService(baseUrl: 'http://192.168.18.198:7187/api');


  List<Product> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      products = await apiService.getProducts();
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToAddProductPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(apiService: apiService),
      ),
    );

    if (result == true) {
      fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('\$${product.price}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _navigateToAddProductPage,
                    child: Text('Add Product'),
                  ),
                ),
              ],
            ),
    );
  }
}

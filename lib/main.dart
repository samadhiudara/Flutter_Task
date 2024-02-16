import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productsData = jsonData['products']; // Access the 'products' key
      if (productsData is List) {
        setState(() {
          products = productsData.map((json) => Product.fromJson(json)).toList();
        });
      } else {
        throw Exception('Invalid data format: $productsData');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product App'),
      ),
      backgroundColor: Colors.white, // Set background color here
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Welcome to the Product App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Browse our collection of products',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: Container(
                      width: 100, // Fixed width
                      height: 100, // Fixed height
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.cover, // Adjust this according to your needs
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text('\$${product.price}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(product.brand),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Product product;

  DetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      backgroundColor: Colors.grey[200], // Set background color to gray
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Details', // Add topic
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Price: \$${product.price}',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Rating: ${product.rating}',
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: product.images
                    .map(
                      (image) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      image,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String thumbnail;
  final String title;
  final double price;
  final String brand;
  final double rating;
  final String description;
  final List<String> images;

  Product({
    required this.thumbnail,
    required this.title,
    required this.price,
    required this.brand,
    required this.rating,
    required this.description,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      brand: json['brand'] ?? '',
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

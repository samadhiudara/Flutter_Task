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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.thumbnail),
            title: Text(product.title),
            subtitle: Text('\$${product.price} - ${product.brand}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(product: product),
                ),
              );
            },
          );
        },
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Price: \$${product.price}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rating: ${product.rating}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Description: ${product.description}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    product.images[index],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
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
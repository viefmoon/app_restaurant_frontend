import 'package:flutter/material.dart';

class ProductCustomizationPage extends StatefulWidget {
  const ProductCustomizationPage({super.key});

  @override
  State<ProductCustomizationPage> createState() => _ProductCustomizationPageState();
}

class _ProductCustomizationPageState extends State<ProductCustomizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ProductCustomizationPage'),
      ), // Center
    ); // Scaffold
  }
}
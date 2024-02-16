import 'package:flutter/material.dart';

class OrderTypeSelectionPage extends StatefulWidget {
  const OrderTypeSelectionPage({super.key});

  @override
  State<OrderTypeSelectionPage> createState() => _OrderTypeSelectionPageState();
}

class _OrderTypeSelectionPageState extends State<OrderTypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('OrderTypeSelectionPage'),
      ), // Center
    ); // Scaffold
  }
}
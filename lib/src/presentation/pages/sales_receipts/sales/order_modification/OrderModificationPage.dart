import 'package:flutter/material.dart';

class OrderModificationPage extends StatefulWidget {
  const OrderModificationPage({super.key});

  @override
  State<OrderModificationPage> createState() => _OrderModificationPageState();
}

class _OrderModificationPageState extends State<OrderModificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('OrderModificationPage'),
      ), // Center
    ); // Scaffold
  }
}
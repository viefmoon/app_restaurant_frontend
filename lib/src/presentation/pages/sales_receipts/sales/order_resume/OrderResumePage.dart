import 'package:flutter/material.dart';

class OrderResumePage extends StatefulWidget {
  const OrderResumePage({super.key});

  @override
  State<OrderResumePage> createState() => _OrderResumePageState();
}

class _OrderResumePageState extends State<OrderResumePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('OrderResumePage'),
      ), // Center
    ); // Scaffold
  }
}
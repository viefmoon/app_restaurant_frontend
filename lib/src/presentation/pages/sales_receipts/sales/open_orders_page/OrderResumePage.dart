import 'package:flutter/material.dart';

class OpenOrdersPage extends StatefulWidget {
  const OpenOrdersPage({super.key});

  @override
  State<OpenOrdersPage> createState() => _OpenOrdersPageState();
}

class _OpenOrdersPageState extends State<OpenOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('OpenOrdersPage'),
      ), // Center
    ); // Scaffold
  }
}
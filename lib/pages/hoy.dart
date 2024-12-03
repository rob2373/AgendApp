import 'package:flutter/material.dart';

class Hoy extends StatefulWidget {
  final int userId;
  const Hoy({super.key, required this.userId});

  @override
  State<Hoy> createState() => _HoyState();
} 

class _HoyState extends State<Hoy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 237, 235, 235),
      body: SingleChildScrollView(
        child: Text("hoy de"  + widget.userId.toString())
      ),
    );
  }
}
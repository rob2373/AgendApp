import 'package:flutter/material.dart';

class NoSave extends StatefulWidget {
   final int userId;
  const NoSave({super.key,required this.userId});

  @override
  State<NoSave> createState() => _NoSaveState();
}

class _NoSaveState extends State<NoSave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255,237, 235, 235),
      body: SingleChildScrollView(
        child: Text("No gurdados"  + widget.userId.toString() )
      ),
    );
  }
}
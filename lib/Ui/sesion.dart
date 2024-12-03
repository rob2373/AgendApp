import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../pages/hoy.dart';
import './inicio.dart';
import '../pages/add.dart';
import '../pages/calendario.dart';
import '../pages/todas.dart';
import '../pages/sinRealizar.dart';

class Sesion extends StatefulWidget {
  final int userId;
  const Sesion({super.key, required this.userId});

  @override
  State<Sesion> createState() => _SesionState();
}

class _SesionState extends State<Sesion> {
  int _paginaActual = 0;

  List<String> _list = [
    'Evento De Hoy',
    'Evento Pendientes',
    'Calendario',
    'Todos Los Evento',
    'Agregar Evento',
  ];
  late List<Widget> _listWidget;
  @override
  void initState() {
    super.initState();
    _listWidget = [
      Hoy(userId: widget.userId),
      NoSave(userId: widget.userId),
      Calendario(userId: widget.userId),
      AllEvents(userId: widget.userId),
      Add(userId: widget.userId),
    ];
  }

  void _logout() {
    // Eliminar la información del usuario (userId)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Inicio()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color.fromARGB(255, 167, 199, 231),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _list[_paginaActual],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ), 
        actions:[
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ], 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Add(userId: widget.userId)));
        },
        backgroundColor: const Color.fromARGB(255, 142, 171, 200),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        buttonBackgroundColor: const Color.fromARGB(255, 167, 199, 231),
        color: const Color.fromARGB(255, 167, 199, 231),
        backgroundColor: const Color.fromARGB(255, 237, 235, 235),
        items: const <Widget>[
          Icon(Icons.today, size: 30),
          Icon(Icons.history, size: 30),
          Icon(Icons.calendar_month, size: 30),
          Icon(Icons.assignment, size: 30),
          Icon(Icons.add_circle)
        ],
      ),
      body: _listWidget[_paginaActual],
    );
  }
}

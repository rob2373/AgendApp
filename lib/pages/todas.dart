import 'package:flutter/material.dart';
import 'package:agendapp/db/db_helper.dart';

class AllEvents extends StatefulWidget {
  final int userId;
  const AllEvents({super.key, required this.userId});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  // Esta función obtiene las reuniones desde la base de datos
  Future<List<Map<String, dynamic>>> _obtenerReuniones() async {
    return await SQLHelper.allReuniones(widget.userId);  // Pasar directamente userId como int
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 235),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _obtenerReuniones(),  // Llamamos a la función para obtener las reuniones
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se cargan los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay un error
            return Center(child: Text('Error al cargar las reuniones'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Si no hay reuniones
            return Center(child: Text('No hay reuniones disponibles'));
          } else {
            // Si ya se cargaron las reuniones
            final reuniones = snapshot.data!;
            return ListView.builder(
              itemCount: reuniones.length,
              itemBuilder: (context, index) {
                final reunion = reuniones[index];
                return ListTile(
                  title: Text(reunion['titulo']),  // Título de la reunión
                  subtitle: Text(
                    'Fecha: ${reunion['fecha']}, Hora: ${reunion['hora']}',  // Muestra fecha y hora
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Aquí puedes implementar la eliminación de reuniones
                    },
                  ),
                  onTap: () {
                    // Aquí puedes implementar la acción al seleccionar una reunión
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

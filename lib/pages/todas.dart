import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para el formato de la hora
import 'package:agendapp/db/db_helper.dart';

class AllEvents extends StatefulWidget {
  final int userId;
  const AllEvents({super.key, required this.userId});
  
  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  // Método para mostrar el diálogo de edición
Future<void> _mostrarDialogoEdicion(Map<String, dynamic> reunion) async {
  // Controladores para los campos de texto
  final tituloController = TextEditingController(text: reunion['titulo']);
  final descripcionController = TextEditingController(text: reunion['descripcion'] ?? '');
  
  // Convertir la fecha y hora existentes a DateTime
  DateTime fechaSeleccionada = DateTime.tryParse(reunion['fecha']) ?? DateTime.now();
  TimeOfDay horaSeleccionada = TimeOfDay.fromDateTime(DateTime.tryParse(reunion['hora'] ?? DateTime.now().toString()) ?? DateTime.now());
  
  final linkUbiController = TextEditingController(text: reunion['link_ubi'] ?? '');
 
  // Variable para manejar el estado
  int estadoActual = reunion['estado'];

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('Editar Reunión'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              
              // Selector de Fecha
              ListTile(
                title: Text('Fecha'),
                subtitle: Text('${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != fechaSeleccionada) {
                    setState(() {
                      fechaSeleccionada = picked;
                    });
                  }
                },
              ),
              
              // Selector de Hora
              ListTile(
                title: Text('Hora'),
                subtitle: Text(horaSeleccionada.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: horaSeleccionada,
                  );
                  if (picked != null && picked != horaSeleccionada) {
                    setState(() {
                      horaSeleccionada = picked;
                    });
                  }
                },
              ),
              
              TextField(
                controller: linkUbiController,
                decoration: InputDecoration(labelText: 'Ubicación/Link'),
              ),
              DropdownButton<int>(
                value: estadoActual,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Pendiente')),
                  DropdownMenuItem(value: 1, child: Text('Completado')),
                  DropdownMenuItem(value: 2, child: Text('Cancelado')),
                ],
                onChanged: (value) {
                  setState(() {
                    estadoActual = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Guardar'),
            onPressed: () async {
              // Validar campos
              if (tituloController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('El título es obligatorio')),
                );
                return;
              }
              
              // Convertir fecha y hora a cadenas para guardar
              String fechaFormateada = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);
              String horaFormateada = horaSeleccionada.format(context);

              // Actualizar en la base de datos
              await SQLHelper.actualizarReunion(
                reunion['id'],
                tituloController.text,
                descripcionController.text,
                fechaFormateada,
                horaFormateada,
                linkUbiController.text,
                estadoActual
              );
              
              // Cerrar el diálogo
              Navigator.of(context).pop();
              
              // Mostrar mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reunión actualizada')),
              );
              
              // Recargar los datos
              setState(() {});
            },
          ),
        ],
      ),
    ),
  );
  
  // Recargar la lista de reuniones
  setState(() {});
}




  // Esta función obtiene las reuniones desde la base de datos
  Future<List<Map<String, dynamic>>> _obtenerReuniones() async {
    return await SQLHelper.allReuniones(widget.userId);
  }

  // Función para manejar el estado de la reunión
  String _getEstadoTexto(int estado) {
    switch (estado) {
      case 0: return 'Pendiente';
      case 1: return 'Completado';
      case 2: return 'Cancelado';
      default: return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Reuniones'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Forzar recarga de los datos
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 237, 235, 235),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _obtenerReuniones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las reuniones'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay reuniones disponibles'));
          } else {
            final reuniones = List<Map<String, dynamic>>.from(snapshot.data!);
            return ListView.builder(
              itemCount: reuniones.length,
              itemBuilder: (context, index) {
                final reunion = reuniones[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ExpansionTile(
                    title: Text(
                      reunion['titulo'], 
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                      'Fecha: ${reunion['fecha']} - Hora: ${reunion['hora']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Descripción
                            Text(
                              'Descripción: ${reunion['descripcion'] ?? 'Sin descripción'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            
                            // Estado
                            Text(
                              'Estado: ${_getEstadoTexto(reunion['estado'])}',
                              style: TextStyle(
                                fontSize: 14,
                                color: reunion['estado'] == 0 
                                  ? Colors.orange 
                                  : reunion['estado'] == 1 
                                    ? Colors.green 
                                    : Colors.red
                              ),
                            ),
                            
                            // Ubicación/Link como texto simple
                            if (reunion['link_ubi'] != null && reunion['link_ubi'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Ubicación/Link: ${reunion['link_ubi']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            
                            SizedBox(height: 10),
                            
                            // Botones de Acciones
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Botón de Editar
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _mostrarDialogoEdicion(reunion);
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text('Editar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                
                                // Botón de Eliminar
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    bool? confirmDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirmar eliminación'),
                                        content: Text('¿Estás seguro de que quieres eliminar esta reunión?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () => Navigator.of(context).pop(false),
                                          ),
                                          TextButton(
                                            child: Text('Eliminar'),
                                            onPressed: () => Navigator.of(context).pop(true),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    if (confirmDelete == true) {
                                      // Eliminar de la base de datos
                                      await SQLHelper.borrarReunion(reunion['id']);
                                      
                                      // Actualizar la vista
                                      setState(() {
                                        reuniones.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Reunión eliminada')),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text('Eliminar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
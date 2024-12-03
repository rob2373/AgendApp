import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para el formato de la hora
import 'package:agendapp/db/db_helper.dart'; // Ajusta a la ruta correcta de tu helper

class Add extends StatefulWidget {
  final int userId;
  const Add({super.key, required this.userId});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
final TextEditingController _tituloController = TextEditingController();
final TextEditingController _descripcionController = TextEditingController(); // Añadido para descripción
final TextEditingController _linkUbiController = TextEditingController();
DateTime _fecha = DateTime.now();
DateTime _hora = DateTime.now();

// Función para mostrar un picker para seleccionar la fecha
Future<void> _selectFecha(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _fecha,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != _fecha) {
    setState(() {
      _fecha = picked;
    });
  }
}

// Función para mostrar un picker para seleccionar la hora
Future<void> _selectHora(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: _hora.hour, minute: _hora.minute),
  );
  if (picked != null) {
    setState(() {
      _hora = DateTime(_hora.year, _hora.month, _hora.day, picked.hour, picked.minute);
    });
  }
}

// Función para insertar la reunión en la base de datos
void _insertarReunion() async {
  final titulo = _tituloController.text;
  final descripcion = _descripcionController.text;  // Ahora tomamos la descripción
  final linkUbi = _linkUbiController.text;

  if (titulo.isEmpty || linkUbi.isEmpty || descripcion.isEmpty) {
    // Mostrar un mensaje de error si faltan campos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, ingrese todos los campos')),
    );
    return;
  }

  // Convertir fecha y hora a cadenas en formato ISO8601
  String fechaString = _fecha.toIso8601String();
  String horaString = _hora.toIso8601String();

  final int result = await SQLHelper.insertarReunion(
    titulo,
    descripcion,  // Pasamos la descripción
    fechaString,  // Pasamos la fecha en formato ISO8601
    horaString,   // Pasamos la hora en formato ISO8601
    linkUbi,
    widget.userId.toString(),
  );

  if (result > 0) {
    // Si se inserta correctamente, mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reunión agregada exitosamente')),
    );
    Navigator.of(context).pop(); // Cerrar el modal después de agregar la reunión
  } else {
    // Si ocurre un error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al agregar la reunión')),
    );
  }
}
  // Función para abrir el showModalBottomSheet
  void _mostrarModalReunion() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Título
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título de la Reunión',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              //desc
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Título de la Reunión',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Fecha
              Row(
                children: [
                  Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_fecha)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectFecha(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hora
              Row(
                children: [
                  Text('Hora: ${DateFormat('HH:mm').format(_hora)}'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectHora(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Link o ubicación
              TextField(
                controller: _linkUbiController,
                decoration: const InputDecoration(
                  labelText: 'Link o Ubicación',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Botón de guardar
              ElevatedButton(
                onPressed: _insertarReunion,
                child: const Text('Guardar Reunión'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 235),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen superior
              const Image(image: AssetImage('assets/img/image.png')),
              const SizedBox(height: 20),
              // Texto superior
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Registrar Nuevo Evento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Selecciona el tipo de evento a registrar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Botones
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _mostrarModalReunion,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Reunión/Evento'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Otros botones
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para "Tarea"
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Tarea'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para "Recordatorio"
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Recordatorio'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para "Rutina"
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Rutina'),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              // Footer con icono
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 40, color: Colors.grey),
                    Text(
                      'AgendaApp',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

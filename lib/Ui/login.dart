import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import './sesion.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? _currentUserId;
  Future<void> _login() async {
    final initSesion = await SQLHelper.login(_usernameController.text,
        _tipoApartadoController.text, _passwordController.text);

    if (initSesion.isNotEmpty) {
      // ususario ya esta registrado
      setState(() {
        _currentUserId = initSesion.first['id'] as int;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Sesion(userId: _currentUserId!)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nombre de usuario o contraseña incorrectos'),
        ),
      );
      return;
    }
        // Limpiar campos
      _usernameController.text = "";
      _tipoApartadoController.text = "";
      _passwordController.text = "";
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tipoApartadoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _tipoApartado = ['Personal', 'Trabajo', 'Estudio'];
  String _selectedTipoApartado = 'Personal';
  bool _mostrarContra = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 167, 199, 231),
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center, // Añadir esta línea
            children: [
              Icon(Icons.login), // Icono en la AppBar
              Text(
                'Inicio de sesión',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Espaciado inicial
              const Image(
                image: AssetImage('assets/img/image.png'),
                height: 150, // Tamaño adaptado para evitar desbordamientos
              ),
              const SizedBox(height: 20),
              const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username:',
                  hintText: 'Ingresa tu username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              //
//DropdownButton
              const Text(
                'Tipo de apartado:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              DropdownButton<String>(
                value: _selectedTipoApartado,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.grey[400],
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTipoApartado = newValue!;
                    _tipoApartadoController.text = newValue;
                  });
                },
                items:
                    _tipoApartado.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              //pass
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_mostrarContra, // Ocultar contraseña
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'Contraseña:',
                  hintText: 'Ingresa tu contraseña',
                  suffixIcon: IconButton(
                      icon: Icon(_mostrarContra
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _mostrarContra = !_mostrarContra;
                        });
                      }),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30), // Espaciado más flexible
              ElevatedButton(
                onPressed: () async {
                  if (_usernameController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _tipoApartadoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Por favor, completa todos los campos')),
                    );
                    return;
                  } else {
                    await _login();
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

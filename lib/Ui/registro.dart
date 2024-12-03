import 'package:flutter/material.dart';
import 'login.dart';
import '../db/db_helper.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});
  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool _mostrarContraR = false;
  bool _mostrarContraC = false;
  bool _registroExitoso = false;
  Future<void> _addData() async {
    try {
      final userExiste = await SQLHelper.login(_usernameController.text,
          _tipoApartadoController.text, _passwordController.text);

      if (userExiste.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El usuario ya está registrado'),
          ),
        );
        return;
      }

      //registrar
      await SQLHelper.insertarData(_usernameController.text,
          _tipoApartadoController.text, _passwordController.text);

      setState(() {
        _registroExitoso = true;
      });

      // Limpiar campos
      _usernameController.text = "";
      _tipoApartadoController.text = "";
      _confirmPassController.text = "";
      _passwordController.text = "";
    } catch (e) {
      setState(() {
        _registroExitoso = false;
      });

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Ocurrió un error al registrar. Por favor, intenta nuevamente.'),
        ),
      );
    }

    // Limpiar campos
    _usernameController.text = "";
    _tipoApartadoController.text = "";
    _passwordController.text = "";
    _confirmPassController.text = "";
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tipoApartadoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final List<String> _tipoApartado = ['Personal', 'Trabajo', 'Estudio'];
  String _selectedTipoApartado = 'Personal';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 167, 199, 231),
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center, // Añadir esta línea
            children: [
              Icon(Icons.person_add), // Icono en la AppBar
              Text(
                'Registro',
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
              const SizedBox(height: 20),
              const Image(
                image: AssetImage('assets/img/image.png'),
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ingresa  tu datos para registrarte.',
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
                obscureText: !_mostrarContraR,
                decoration: InputDecoration(
                    labelText: 'Contraseña:',
                    hintText: 'Ingresa tu contraseña',
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarContraR = !_mostrarContraR;
                          });
                        },
                        icon: Icon(_mostrarContraR
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPassController,
                obscureText: !_mostrarContraC,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'Confirmar contraseña',
                  hintText: 'Confirma tu contraseña',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _mostrarContraC = !_mostrarContraC;
                      });
                    },
                    icon: Icon(_mostrarContraC
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),
              //boton de registrar
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if(_usernameController.text.isEmpty|| _passwordController.text.isEmpty 
                        ||_confirmPassController.text.isEmpty || _tipoApartadoController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor, completa todos los campos')),
                              );
                                    return;
                        }
                        else if (_passwordController.text ==
                            _confirmPassController.text) {
                          await _addData();
                          _usernameController.text = "";
                          _tipoApartadoController.text = "";
                          _passwordController.text = "";
                          _confirmPassController.text = "";
                        } else {
                          // Mostrar mensaje de error
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Las contraseñas no coinciden. Por favor, asegúrate de que ambas contraseñas sean iguales e inténtalo de nuevo.'),
                          ));
                        }
                        /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login())); */
                      },
                      child: const Text('Registrar'))
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _registroExitoso
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}

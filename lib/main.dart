import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}
class MainApp extends StatefulWidget {  
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 142, 171, 200),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: const Color.fromARGB(255, 167, 199, 231),
          color: const Color.fromARGB(255, 167, 199, 231),
          backgroundColor: const Color.fromARGB(255, 237, 235, 235),
          items: const <Widget>[
            Icon(Icons.today, size: 30),
            Icon(Icons.history, size: 30),
            Icon(Icons.calendar_month, size: 30),
            Icon(Icons.assignment, size: 30),
          ],
        ),
        body: Container(color: const Color.fromARGB(255, 237, 235, 235)),
      ),
    );
  }
}

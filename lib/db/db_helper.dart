import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        typeSection TEXT NOT NULL,
        pass TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE reunionEve (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha  TEXT NULL,
        hora TEXT NOT NULL,
        link_ubi TEXT,
        estado INTEGER NOT NULL DEFAULT 0,
        fk_usuario INTEGER NOT NULL,
        FOREIGN KEY (fk_usuario) REFERENCES users(id)
      )
    ''');

    await database.execute('''
      CREATE TABLE tareas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha_limite TEXT NOT NULL,
        prioridad TEXT NOT NULL,
        estado INTEGER NOT NULL DEFAULT 0,
        fk_usuario INTEGER NOT NULL,
        FOREIGN KEY (fk_usuario) REFERENCES users(id)
      )
    ''');

    await database.execute('''
      CREATE TABLE recordatorioS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        estado INTEGER NOT NULL DEFAULT 0,
        fk_usuario INTEGER NOT NULL,
        FOREIGN KEY (fk_usuario) REFERENCES users(id)
      )
    ''');

    await database.execute('''
      CREATE TABLE rutina (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        dias_repetir TEXT NOT NULL,
        hora TEXT NOT NULL,
        estado INTEGER NOT NULL DEFAULT 0,
        fk_usuario INTEGER NOT NULL,
        FOREIGN KEY (fk_usuario) REFERENCES users(id)
      )
    ''');

    // Create indexes for foreign keys
    await database.execute(
        'CREATE INDEX idx_reunionEve_fk_usuario ON reunionEve(fk_usuario)');
    await database
        .execute('CREATE INDEX idx_tareas_fk_usuario ON tareas(fk_usuario)');
    await database.execute(
        'CREATE INDEX idx_recordatorioS_fk_usuario ON recordatorioS(fk_usuario)');
    await database
        .execute('CREATE INDEX idx_rutina_fk_usuario ON rutina(fk_usuario)');
  }

  static Future<sql.Database> db() async {
    final dbPath = join(await sql.getDatabasesPath(), 'agendapp.db');
    // Eliminar la base de datos si existe 
    
    return sql.openDatabase(dbPath, version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

//registro y login
  static Future<int> insertarData(
      String username, String typeSection, String pass) async {
    final db = await SQLHelper.db();
    final data = {
      'username': username,
      'typeSection': typeSection,
      'pass': pass
    };
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> login(
      String username, String typeSection, String pass) async {
    final db = await SQLHelper.db();
    return db.query('users',
        where: "username = ? AND typeSection = ? AND pass = ?",
        whereArgs: [username, typeSection, pass],
        limit: 1);
  }

  // reunion
  static Future<int> insertarReunion(String titulo, String descripcion,
      String fecha, String hora, String linkUbi, String fkUsuario) async {
    final db = await SQLHelper.db();
    final dataReunion = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'hora': hora,
      'link_ubi': linkUbi,
      'fk_usuario': int.parse(fkUsuario)
    };
    return db.insert('reunionEve', dataReunion,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

// Cambia fkUsuario de String a int
static Future<List<Map<String, dynamic>>> allReuniones(int fkUsuario) async {
  final db = await SQLHelper.db();
  try {
    // Realiza la consulta con el fk_usuario directamente como int
    return await db.query(
      'reunionEve',
      where: "fk_usuario = ?",
      whereArgs: [fkUsuario],  // Aquí ya no necesitamos parsear
    );
  } catch (e) {
    // Manejo de errores
    print("Error al obtener reuniones: $e");
    return [];  // Devuelve una lista vacía si hay un error
  }
}
  //tarea

  // recordatorio

  // rutina
}

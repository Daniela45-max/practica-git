import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb_shim.dart';
import 'dart:async';
import '../models/note.dart'; // Asegúrate de que este path sea correcto

class DBService {
  // 1. Patrón Singleton: Garantiza una sola instancia de la clase
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  // 2. Estado de la base de datos
  Database? _db;
  static const String dbName = 'notas_db';
  static const String storeName = 'notes';

  // Método de inicialización (llamar una vez al inicio de la app)
  Future<void> init() async {
    if (_db != null) return; // Si ya está inicializada, no hace nada

    // Usamos idbFactoryBrowser para garantizar el uso de IndexedDB en el entorno web (PWA)
    IdbFactory idbFactory = idbFactoryBrowser;
    
    try {
        _db = await idbFactory.open(dbName, version: 1,
            onUpgradeNeeded: (VersionChangeEvent e) {
          Database db = e.database;
          if (!db.objectStoreNames.contains(storeName)) {
            // Crea el almacén de objetos. keyPath: 'id' es CRUCIAL.
            db.createObjectStore(storeName, keyPath: 'id'); 
          }
        });
        print('IndexedDB inicializada con éxito.');
    } catch (e) {
        print('Error al inicializar IndexedDB: $e');
        // Manejo de errores
    }
  }

  // Las operaciones ahora acceden a la instancia única '_db'

  Future<void> saveNote(Note note) async {
    // Es vital asegurarse de que la BD esté abierta antes de cualquier operación
    if (_db == null) await init(); 
    
    final txn = _db!.transaction(storeName, idbModeReadWrite);
    final store = txn.objectStore(storeName);
    
    // put() inserta si no existe el ID, o actualiza si existe
    await store.put(note.toJson()); 
    await txn.completed;
  }

  Future<List<Note>> getAllNotes() async {
    if (_db == null) await init(); 
    
    final txn = _db!.transaction(storeName, idbModeReadOnly);
    final store = txn.objectStore(storeName);
    
    // Obtener todos los elementos
    final items = await store.getAll(); 
    await txn.completed;

    // Mapear los Maps de IndexedDB a objetos Note
    return items.map((e) => Note.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> deleteNote(String id) async {
    if (_db == null) await init();
    
    final txn = _db!.transaction(storeName, idbModeReadWrite);
    final store = txn.objectStore(storeName);
    
    await store.delete(id);
    await txn.completed;
  }
}
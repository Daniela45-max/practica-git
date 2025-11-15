import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_edit_screen.dart';
import '../services/db_service.dart';
import '../models/note.dart';
import '../services/pwa_manager.dart'; 
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBService db = DBService(); 
  List<Note> notes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes(); 
  }

  Future<void> _loadNotes() async {
    setState(() => loading = true);
    notes = await db.getAllNotes(); 
    setState(() => loading = false);
  }

  void _add() async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final note = Note(id: id, title: 'Nota nueva', body: '', updated: now);
    
    await db.saveNote(note); 
    
    setState(() {
      notes.insert(0, note);
    });
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)))
        .then((result) {
          if (result == true) { 
            _loadNotes();
          }
        });
  }

  void _edit(Note note) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)))
        .then((result) {
          if (result == true) {
            _loadNotes();
          }
        });
  }

  void _delete(String id) async {
    await db.deleteNote(id);
    setState(() {
      notes.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pwaManager = Provider.of<PWAManager>(context);
    final isOnline = pwaManager.isOnline;
    
    // Se accede al color de acento
    final accentColor = theme.colorScheme.secondary; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas PWA'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24.0),
          child: Container(
            color: isOnline ? Colors.teal : Colors.redAccent, 
            alignment: Alignment.center,
            child: Text(
              isOnline ? 'Online' : 'Offline Mode',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: accentColor, 
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined, 
                    size: 80, 
                    color: theme.colorScheme.onSurface.withOpacity(0.3)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay notas. Toca "+" para crear una.', 
                    style: TextStyle(
                      fontSize: 18, 
                      color: theme.textTheme.bodyMedium!.color!.withOpacity(0.7)
                    )
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final n = notes[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    // ESTILOS APLICADOS DIRECTAMENTE AQUI:
                    elevation: 4, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        n.title, 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      subtitle: Text(
                        'Ultima edicion: ${n.updated.toLocal().toString().substring(0, 16)}'
                      ),
                      leading: Icon(Icons.description, color: accentColor), 
                      onTap: () => _edit(n),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent), 
                          onPressed: () => _delete(n.id)
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
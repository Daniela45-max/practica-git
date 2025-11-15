import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/db_service.dart';

class NoteEditScreen extends StatefulWidget {
 final Note note;
 const NoteEditScreen({super.key, required this.note});

 @override
 State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
 late TextEditingController titleCtrl;
 late TextEditingController bodyCtrl;
 final DBService db = DBService();

 @override
 void initState() {
 super.initState();
 titleCtrl = TextEditingController(text: widget.note.title);
 bodyCtrl = TextEditingController(text: widget.note.body);
 }

 @override
 void dispose() {
 titleCtrl.dispose();
 bodyCtrl.dispose();
 super.dispose();
 }

 Future<void> _save() async {
 
    if (titleCtrl.text.trim().isEmpty) {
        
    }
    
 final n = widget.note;
 n.title = titleCtrl.text;
 n.body = bodyCtrl.text;
 n.updated = DateTime.now();
    
 // 1. Guardar la nota en IndexedDB (Trabajo Offline)
 await db.saveNote(n);
    
 // 2. Devolver 'true' a la pantalla anterior para indicar que hubo un cambio.
 Navigator.pop(context, true); 
 }

 @override
 Widget build(BuildContext context) {
 return PopScope(
        
        canPop: false,
        onPopInvoked: (didPop) async {
            if (didPop) return;
            await _save();
        },
        child: Scaffold(
 appBar: AppBar(
 title: const Text('Editar nota'),
 actions: [
 IconButton(icon: const Icon(Icons.save), onPressed: _save),
         
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: _save),
 ],
 ),
 body: Padding( padding: const EdgeInsets.all(12),
 child: Column(
     children: [
 TextField(
                controller: titleCtrl, 
                decoration: const InputDecoration(labelText: 'Titulo'),
                
                onSubmitted: (_) => _save(),
            ),
 const SizedBox(height: 12),
 Expanded(
                child: TextField(
                    controller: bodyCtrl, 
                    decoration: const InputDecoration(labelText: 'Contenido'), 
                    maxLines: null, 
                    expands: true,
                    
                    onSubmitted: (_) => _save(),
                )
            ),
             ],
),
 ),
  )
    );
     }
}
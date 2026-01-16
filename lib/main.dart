import 'package:flutter/material.dart';
import 'database/database_manager.dart';
import 'modele/redacteur.dart';


void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title : 'Redacteur',
        home: const RedacteurInterface(),
      );
    );
  }
}

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _loadRedacteurs();
  }

  Future<void> _loadRedacteurs() async {
    final data = await DatabaseManager().getAllRedacteurs();
    setState(() {
      _redacteurs = data;
    });
  }

  // ✏️ MÉTHODE DE MODIFICATION (AU BON ENDROIT)
  void _showEditDialog(Redacteur redacteur) {
    final TextEditingController nomCtrl =
        TextEditingController(text: redacteur.nom);
    final TextEditingController prenomCtrl =
        TextEditingController(text: redacteur.prenom);
    final TextEditingController emailCtrl =
        TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le rédacteur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = Redacteur.fromMap(
                  redacteur.id,
                  nomCtrl.text,
                  prenomCtrl.text,
                  emailCtrl.text,
                );

                await DatabaseManager().updateRedacteur(updated);
                Navigator.pop(context);
                await _loadRedacteurs();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Gestion des rédacteurs',
          style: TextStyle(color: 
            Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final nom = _nomController.text;
                final prenom = _prenomController.text;
                final email = _emailController.text;

                if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
                  return;
                }

                final redacteur = Redacteur(nom, prenom, email);
                await DatabaseManager().insertRedacteur(redacteur);

                _nomController.clear();
                _prenomController.clear();
                _emailController.clear();

                await _loadRedacteurs();
              },
              child: const Text('Ajouter un rédacteur'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _redacteurs.length,
                itemBuilder: (context, index) {
                  final redacteur = _redacteurs[index];

                  return Card(
                    child: ListTile(
                      title: Text('${redacteur.nom} ${redacteur.prenom}'),
                      subtitle: Text(redacteur.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditDialog(redacteur);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseManager()
                                  .deleteRedacteur(redacteur.id!);
                              await _loadRedacteurs();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
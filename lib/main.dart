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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Gestion des rédacteurs',),

      ),
       body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ],
          const SizedBox(height: 20,),

          ElevatedButton(
            onPressed: () async {
              final nom = _nomController.text;
              final prenom = _prenomController.text;
              final email = _emailController.text;

               if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
                return;
            },

            final redacteur = Redacteur(nom, prenom, email);

            await DatabaseManager().insertRedacteur(redacteur);

            _nomController.clear();
            _prenomController.clear();
            _emailController.clear();

          )
        ),
      ),
    );
  }
}
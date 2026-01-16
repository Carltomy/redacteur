class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  Redacteur(this.nom, this.prenom, this.email);

  Redacteur.fromMap(this.id, this.nom, this.prenom, this.email);

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }
}

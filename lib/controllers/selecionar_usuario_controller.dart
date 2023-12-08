import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_faculdade/entidades/atleta.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';

class SelecionarUsuarioController {

  Future<void> getUsersAthletesWithout() async {
    List<Atleta> athletes = [];
    List<Usuario> usersWithout = [];
    users.clear();

    var res = await FirebaseFirestore.instance.collection('usuarios').where('tipo', isEqualTo: 'atleta').where('ativo', isEqualTo: true).get();
    var docs = res.docs;

    for (var doc in docs) {
      var obj =  Usuario.fromSnapshot(doc);
      users.add(obj);
    }

    var resAthletes = await FirebaseFirestore.instance.collection('atletas').where('ativo', isEqualTo: true).get();
    var docsAthletes = resAthletes.docs;

    for (var doc in docsAthletes) {
      var obj =  Atleta.fromSnapshot(doc);
      athletes.add(obj);
    }

    usersWithout.addAll(users);

    for (var user in users) {
      if (athletes.indexWhere((e) => e.usuario.idUsuario == user.idUsuario) >= 0) {
        usersWithout.remove(user);
      }
    }

    users.clear();
    users.addAll(usersWithout);
  }

  Future<void> getAthletesValidate() async {
    List<Atleta> athletes = [];
    List<Usuario> usersWithout = [];

    users.clear();

    var res = await FirebaseFirestore.instance.collection('usuarios').where('tipo', isEqualTo: 'atleta').where('ativo', isEqualTo: true).get();
    var docs = res.docs;

    for (var doc in docs) {
      var obj =  Usuario.fromSnapshot(doc);
      users.add(obj);
    }

    var resAthletes = await FirebaseFirestore.instance.collection('atletas').where('ativo', isEqualTo: true).where('validar', isEqualTo: true).get();
    var docsAthletes = resAthletes.docs;

    for (var doc in docsAthletes) {
      var obj =  Atleta.fromSnapshot(doc);
      athletes.add(obj);
    }

    for (var user in users) {
      if (athletes.indexWhere((e) => e.usuario.idUsuario == user.idUsuario) >= 0) {
        usersWithout.add(user);
      }
    }

    users.clear();
    users.addAll(usersWithout);
  }

  Future<void> getControlResponsible() async {
    users.clear();

    var res = await FirebaseFirestore.instance.collection('usuarios').where('ativo', isEqualTo: true).get();
    var docs = res.docs;

    for (var doc in docs) {
      var obj =  Usuario.fromSnapshot(doc);

      if (obj.tipo != "administrador") {
        users.add(obj);
      }
    }
  }

  Future<List<Atleta>> getAthletesBySex(String sex) async {
    List<Atleta> athletes = [];

    var res = await FirebaseFirestore.instance.collection('atletas').where('ativo', isEqualTo: true).where('sexo', isEqualTo: sex).get();
    var docs = res.docs;

    for (var doc in docs) {
      var obj =  Atleta.fromSnapshot(doc);

      athletes.add(obj);
    }

    return athletes;
  }

  Future<List<Usuario>> getAllAthletes() async {
    await getAthletesValidate();
    return users;
  }

  List<Usuario> users = [];
}

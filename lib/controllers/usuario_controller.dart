import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/util/firebase_errors.dart';
import 'package:trabalho_faculdade/widgets/toast_message.dart';

class UsuarioController {
  Future<bool> saveUser(Usuario usuario) async {
    bool res = false;

    try {
      if (usuario.idUsuario == "") {
        final UserCredential result = await auth
            .createUserWithEmailAndPassword(
            email: usuario.email,
            password: usuario.senha)
            .catchError((e) {
          showToast(getErrorString(e.code));
        });

        usuario.idUsuario = result.user!.uid;
      }

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.idUsuario)
          .set(usuario.toMap());

      res = true;
    } catch (_) {
      res = false;
    }

    return res;
  }

  Future<bool> excluir(Usuario usuario) async {
    bool res = false;

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.idUsuario)
          .update({'ativo': false});

      res = true;
    } catch (_) {
      res = false;
    }

    return res;
  }



  Future<void> getData(Usuario user) async {
    users.clear();
    var res = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('ativo', isEqualTo: true)
        .get();

    var docs = res.docs;

    for (var doc in docs) {
      var obj = Usuario.fromSnapshot(doc);
      users.add(obj);
    }
  }

  List<Usuario> users = [];
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
}

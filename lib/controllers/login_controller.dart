import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/util/firebase_errors.dart';
import 'package:trabalho_faculdade/util/pref.dart';
import 'package:trabalho_faculdade/widgets/toast_message.dart';

class LoginController {
  Future<bool> onLogin(String email, String senha) async {
    bool res = false;

    try {
      isLoading = true;

      final UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: senha).catchError((e) async {
        showToast(getErrorString(e.code));
        return false;
      });
      await _loadCurrentUser(firebaseUser: result.user!);
      res = true;

    } catch (_) {
      res = false;
    } finally {
      isLoading = false;
    }

    return res;
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final User? currentUser = firebaseUser ?? auth.currentUser;

    if(currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('usuarios').doc(currentUser.uid).get();

      if (docUser.exists) {
        Usuario user = Usuario.fromSnapshot(docUser);
        await Pref.saveUser(user!);
      }
    }
  }

  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}
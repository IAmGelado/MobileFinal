import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho_faculdade/widgets/toast_message.dart';

class RecuperacaoSenhaController {

  Future<void> enviarLink(String email) async {
    try {
      isLoading = true;

      final QuerySnapshot query = await FirebaseFirestore.instance.collection('usuarios').where('email', isEqualTo: email).get();

      if (query.docs.isEmpty) {
        showToast("Não existe usuário com esse email");
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showToast("Link enviado no email");
      }
    } catch (_) {
    } finally {
      isLoading = false;
    }
  }

  bool isLoading = false;
}
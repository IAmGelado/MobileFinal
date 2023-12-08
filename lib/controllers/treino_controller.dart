import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_faculdade/entidades/treino.dart';

class TreinoController {
  Future<void> getData() async {
    training.clear();

    var res = await FirebaseFirestore.instance.collection('treinos').get();
    var docs = res.docs;

    for (var doc in docs) {
      var obj =  Treino.fromSnapshot(doc);
      training.add(obj);
    }
  }

  Future<bool> salvar(Treino treino) async {
    bool res = false;

    try {
      if (treino.id == "") {
        await FirebaseFirestore.instance
            .collection('treinos')
            .add(treino.toMap());
      } else {
        await FirebaseFirestore.instance
            .collection('treinos')
            .doc(treino.id)
            .set(treino.toMap());
      }
      res = true;
    } catch (_) {
      res = false;
    }

    return res;
  }

  bool isLoading = false;
  List<Treino> training = [];
}
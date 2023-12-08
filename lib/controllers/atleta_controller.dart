import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho_faculdade/entidades/atleta.dart';
import 'package:trabalho_faculdade/entidades/telefone.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/util/firestore.dart';
import 'package:trabalho_faculdade/widgets/toast_message.dart';

class AtletaController {

  Future<bool> salvar(Atleta atleta) async {
    bool res = false;

    atleta.urlAtestadoMedico = pathAtestadoMedico.contains('https://')
        ? pathAtestadoMedico
        : await uploadFile(atestadoMedico, 'atestadoMedico');

    atleta.urlArquivoCpf = pathCPf.contains('https://')
    ? pathCPf
        : await uploadFile(arquivoCPF, 'arquivoCPF');

    atleta.urlArquivoRg = pathRg.contains('https://')
    ? pathRg
        : await uploadFile(arquivoRg, 'arquivoRg');

    atleta.urlFoto3X4 = pathFoto.contains('https://')
    ? pathFoto
        : await uploadFile(foto, 'foto');

    atleta.urlComprovanteEndereco = pathComprovanteEndereco.contains('https://')
    ? pathComprovanteEndereco
        : await uploadFile(comprovanteEndereco, 'comprovanteEndereco');

    atleta.urlRegulamento = pathRegulamento.contains('https://')
    ? pathRegulamento
        : await uploadFile(regulamento, 'regulamento');


    try {
      if (atleta.atletaID.isEmpty) {
        await FirebaseFirestore.instance
            .collection('atletas')
            .add(atleta.toMap());
      } else {
        await FirebaseFirestore.instance
            .collection('atletas')
            .doc(atleta.atletaID)
            .set(atleta.toMap());
      }
      res = true;

    } catch (_) {
      res = false;
    }

    return res;
  }

  Future<bool> deletar(Atleta atleta) async {
    bool res = false;

    try {
      await FirebaseFirestore.instance
          .collection('atletas')
          .doc(atleta.atletaID)
          .update({'ativo': false});
      res = true;
    } catch (_) {
      res = false;
    }

    return res;
  }

  Future<void> setMedicalCertificate() async {
    var file = await getFile();
    if (file != null) {
      atestadoMedico = file;
      pathAtestadoMedico = atestadoMedico.path
          .split('/')
          .last;
    }
  }

  Future<void> setFileRg() async {
    var file = await getFile();
    if (file != null) {
      arquivoRg = file;
      pathRg = arquivoRg.path
          .split('/')
          .last;
    }
  }

  Future<void> setFileCpf() async {
    var file = await getFile();
    if (file != null) {
      arquivoCPF = file;
      pathCPf = arquivoCPF.path
          .split('/')
          .last;
    }
  }

  Future<void> setProofOfAddress() async {
    var file = await getFile();
    if (file != null) {
      comprovanteEndereco = file;
      pathComprovanteEndereco = comprovanteEndereco.path
          .split('/')
          .last;
    }
  }

  Future<void> setPhoto3X4() async {
    var file = await getFile();
    if (file != null) {
      foto = file;
      pathFoto = foto.path
          .split('/')
          .last;
    }
  }

  Future<void> setRegulation() async {
    var file = await getFile();
    if (file != null) {
      regulamento = file;
      pathRegulamento = regulamento.path
          .split('/')
          .last;
    }
  }

  Future<void> getData(Usuario user) async {
    athletes.clear();
    var res = await FirebaseFirestore.instance
        .collection('atletas')
        .where('ativo', isEqualTo: true)
        .get();

    var docs = res.docs;

    for (var doc in docs) {
      var obj = Atleta.fromSnapshot(doc);
      athletes.add(obj);
    }
  }


  List<Atleta> athletes = [];
  bool isLoading = false;
  Telefone phone = Telefone(telefone: "", tipo: "");
  Usuario user = Usuario(idUsuario: "", nome: "", email: "", senha: "", tipo: "", ativo: false);
  final FirebaseAuth auth = FirebaseAuth.instance;

  File atestadoMedico = File("");
  File arquivoRg = File("");
  File arquivoCPF = File("");
  File comprovanteEndereco = File("");
  File foto = File("");
  File regulamento = File("");

  String pathAtestadoMedico = "";
  String pathRg = "";
  String pathCPf = "";
  String pathComprovanteEndereco = "";
  String pathFoto = "";
  String pathRegulamento = "";
}

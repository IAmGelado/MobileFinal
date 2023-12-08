import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String idUsuario;
  String nome;
  String email;
  String senha;
  String tipo;
  bool ativo;

  Usuario({
    required this.idUsuario,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
    required this.ativo,
  });

  Usuario.fromMap(Map<String, dynamic> mapa)
      : idUsuario = mapa['idUsuario'],
        nome = mapa['nome'],
        email = mapa['email'],
        senha = mapa['senha'],
        tipo = mapa['tipo'],
        ativo = mapa['ativo'];

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : idUsuario = snapshot.id,
        nome = snapshot["nome"],
        email = snapshot["email"],
        senha = "",
        tipo = snapshot["tipo"],
        ativo = snapshot["ativo"];

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      nome: json["nome"],
      email: json["email"],
      senha: "",
      tipo: json["tipo"],
      ativo: json["ativo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
      'ativo': ativo,
    };
  }
}
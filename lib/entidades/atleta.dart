import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_faculdade/entidades/telefone.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';

class Atleta {
  String atletaID;
  Usuario usuario;
  String dataNascimento;
  String localNascimento;
  String nacionalidade;
  String rg;
  String cpf;
  String sexo;
  String enderecoCompleto;
  String nomeMae;
  String nomePai;
  String clubeOrigem;
  String localTrabalho;
  String convenioMedico;
  String urlAtestadoMedico;
  String urlArquivoRg;
  String urlArquivoCpf;
  String urlComprovanteEndereco;
  String urlFoto3X4;
  String urlRegulamento;
  List<String> alergias;
  List<String> estilos;
  List<String> provas;
  List<Telefone> telefones;
  bool ativo;
  bool validar;

  Atleta({
    required this.atletaID,
    required this.usuario,
    required this.dataNascimento,
    required this.localNascimento,
    required this.nacionalidade,
    required this.rg,
    required this.cpf,
    required this.sexo,
    required this.enderecoCompleto,
    required this.nomeMae,
    required this.nomePai,
    required this.clubeOrigem,
    required this.localTrabalho,
    required this.convenioMedico,
    required this.alergias,
    required this.estilos,
    required this.provas,
    required this.telefones,
    required this.urlAtestadoMedico,
    required this.urlArquivoRg,
    required this.urlArquivoCpf,
    required this.urlComprovanteEndereco,
    required this.urlFoto3X4,
    required this.urlRegulamento,
    required this.ativo,
    required this.validar,
  });

  factory Atleta.fromSnapshot(DocumentSnapshot snapshot) {
    return Atleta(
      atletaID: snapshot.id,
      usuario: Usuario.fromJson(snapshot["usuario"]),
      dataNascimento: snapshot["dataNascimento"],
      localNascimento: snapshot["localNascimento"],
      nacionalidade: snapshot["nacionalidade"],
      rg: snapshot["rg"],
      cpf: snapshot["cpf"],
      sexo: snapshot["sexo"],
      enderecoCompleto: snapshot["enderecoCompleto"],
      nomeMae: snapshot["nomeMae"],
      nomePai: snapshot["nomePai"],
      clubeOrigem: snapshot["clubeOrigem"],
      localTrabalho: snapshot["localTrabalho"],
      convenioMedico: snapshot["convenioMedico"],
      alergias: List<String>.from(snapshot['alergias'] ?? []),
      estilos: List<String>.from(snapshot['estilos'] ?? []),
      provas: List<String>.from(snapshot['provas'] ?? []),
      telefones: (snapshot['telefones'] as List<dynamic>?)
          ?.map((telefone) => Telefone.fromJson(telefone))
          .toList() ??
          [],
      ativo: snapshot["ativo"],
      validar: snapshot["validar"],
      urlAtestadoMedico: snapshot["urlAtestadoMedico"],
      urlArquivoRg: snapshot["urlArquivoRg"],
      urlArquivoCpf: snapshot["urlArquivoCpf"],
      urlComprovanteEndereco: snapshot["urlComprovanteEndereco"],
      urlFoto3X4: snapshot["urlFoto3X4"],
      urlRegulamento: snapshot["urlRegulamento"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "atletaID": atletaID,
      "usuario": usuario.toMap(),
      "dataNascimento": dataNascimento,
      "localNascimento": localNascimento,
      "nacionalidade": nacionalidade,
      "rg": rg,
      "cpf": cpf,
      "sexo": sexo,
      "enderecoCompleto": enderecoCompleto,
      "nomeMae": nomeMae,
      "nomePai": nomePai,
      "clubeOrigem": clubeOrigem,
      "localTrabalho": localTrabalho,
      "convenioMedico": convenioMedico,
      'alergias': alergias,
      'estilos': estilos,
      'provas': provas,
      'telefones': telefones.map((telefone) => telefone.toMap()).toList(),
      'ativo': ativo,
      'validar': validar,
      "urlAtestadoMedico": urlAtestadoMedico,
      "urlArquivoRg": urlArquivoRg,
      "urlArquivoCpf": urlArquivoCpf,
      "urlComprovanteEndereco": urlComprovanteEndereco,
      "urlFoto3X4": urlFoto3X4,
      "urlRegulamento": urlRegulamento,
    };
  }
}
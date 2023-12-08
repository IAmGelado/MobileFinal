import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';

class Treino {
  String id;
  String estilo;
  String prova;
  String numero;
  Usuario atleta;
  String data;
  double frequenciaInicio;
  double frequenciaFim;
  Usuario responsavelControle;
  double ultimaVolta;
  bool ultimaVoltaConcluida;
  List<int> tempoPor100;
  bool ativo;

  Treino({
    required this.id,
    required this.estilo,
    required this.prova,
    required this.numero,
    required this.atleta,
    required this.data,
    required this.frequenciaInicio,
    required this.frequenciaFim,
    required this.responsavelControle,
    required this.ultimaVolta,
    required this.ultimaVoltaConcluida,
    required this.tempoPor100,
    required this.ativo,
  });

  Treino.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        estilo = json['estilo'],
        prova = json['prova'],
        numero = json['numero'],
        atleta = Usuario.fromJson(json['atleta']),
        data = json['data'],
        frequenciaInicio = json['frequenciaInicio'],
        frequenciaFim = json['frequenciaFim'],
        responsavelControle = Usuario.fromJson(json['responsavelControle']),
        ultimaVolta = json['ultimaVolta'],
        ultimaVoltaConcluida = json['ultimaVoltaConcluida'],
        tempoPor100 = List<int>.from(json['tempoPor100']),
        ativo = json['ativo'];

  factory Treino.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Treino(
      id: snapshot.id,
      estilo: data['estilo'],
      prova: data['prova'],
      numero: data['numero'],
      atleta: Usuario.fromJson(data['atleta']),
      data: data['data'],
      frequenciaInicio: (data['frequenciaInicio'] ?? 0.0).toDouble(),
      frequenciaFim: (data['frequenciaFim'] ?? 0.0).toDouble(),
      responsavelControle: Usuario.fromJson(data['responsavelControle']),
      ultimaVolta: data['ultimaVolta'],
      ultimaVoltaConcluida: data['ultimaVoltaConcluida'],
      tempoPor100: List<int>.from(data['tempoPor100']),
      ativo: data['ativo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estilo': estilo,
      'prova': prova,
      'numero': numero,
      'atleta': atleta.toMap(),
      'data': data,
      'frequenciaInicio': frequenciaInicio,
      'frequenciaFim': frequenciaFim,
      'responsavelControle': responsavelControle.toMap(),
      'ultimaVolta': ultimaVolta,
      'ultimaVoltaConcluida': ultimaVoltaConcluida,
      'tempoPor100': tempoPor100,
      'ativo': ativo,
    };
  }
}
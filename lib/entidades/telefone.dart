class Telefone {
  String telefone;
  String tipo;

  Telefone({required this.telefone, required this.tipo});

  factory Telefone.fromMap(Map<String, dynamic> map) {
    return Telefone(
      telefone: map['telefone'],
      tipo: map['tipo'],
    );
  }

  factory Telefone.fromJson(Map<String, dynamic> json) {
    return Telefone(
      telefone: json['telefone'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'telefone': telefone,
      'tipo': tipo,
    };
  }
}
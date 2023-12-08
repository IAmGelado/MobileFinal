class TempoTreino {
  String minutos;
  String segundos;
  String milisegundos;

  TempoTreino({required this.minutos, required this.segundos, required this.milisegundos});

  Map<String, dynamic> toMap() {
    return {
      'minutos': minutos,
      'segundos': segundos,
      'milisegundos': milisegundos
    };
  }
}
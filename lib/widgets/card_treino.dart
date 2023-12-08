import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/treino.dart';
import 'package:trabalho_faculdade/util/timer.dart';

class CardTreino extends StatelessWidget {
  CardTreino({Key? key, required this.trainingModel}) : super(key: key);

  Treino trainingModel;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estilo do Treino: ${trainingModel.estilo}', style: const TextStyle(fontSize: 16)),
            Text('Número do Treino: ${trainingModel.numero}', style: const TextStyle(fontSize: 16)),
            Text('Atleta: ${trainingModel.atleta.nome}', style: const TextStyle(fontSize: 16)),
            Text('Data do Treino: ${trainingModel.data}', style: const TextStyle(fontSize: 16)),
            Text('Frequência Cardíaca Início: ${trainingModel.frequenciaInicio}', style: const TextStyle(fontSize: 16)),
            Text('Frequência Cardíaca Final: ${trainingModel.frequenciaFim}', style: const TextStyle(fontSize: 16)),
            const Text('Tempos por 100 Metros (até 30 minutos):', style: TextStyle(fontSize: 16)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: trainingModel.tempoPor100!.length,
              itemBuilder: (context, index) {
                final time = trainingModel.tempoPor100![index];
                final status = time < 0.8 * trainingModel.frequenciaFim!
                    ? 'Abaixo da Média'
                    : time <= 1.2 * trainingModel.frequenciaFim!
                    ? 'Na Média'
                    : 'Acima da Média';

                return ListTile(
                  title: Text('Tempo: ${index + 1}: ${getTimeToString(time)}'),
                  subtitle: Text('Status: $status'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

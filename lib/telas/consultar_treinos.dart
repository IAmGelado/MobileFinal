import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/telas/treino.dart';
import 'package:trabalho_faculdade/controllers/treino_controller.dart';

class ConsultarTreinos extends StatefulWidget {
  const ConsultarTreinos({Key? key}) : super(key: key);

  @override
  State<ConsultarTreinos> createState() => _ConsultarTreinosState();
}

class _ConsultarTreinosState extends State<ConsultarTreinos> {
  TreinoController state = TreinoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treinos"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (builder) => TreinoTela(state: state)));
            setState(() {});
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: state.getData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                      itemCount: state.training.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (builder) => TreinoTela(state: state, treino: state.training[index],)));
                            setState(() {});
                          },
                          child: ListTile(
                            title: Text(state.training[index].numero),
                            subtitle: Text(state.training[index].data),
                            trailing: const Icon(Icons.arrow_forward_outlined),
                          ),
                        );
                      });
                }
            }
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/controllers/atleta_controller.dart';
import 'package:trabalho_faculdade/telas/atleta.dart';

class ConsultarAtletas extends StatefulWidget {
  ConsultarAtletas({Key? key, required this.user}) : super(key: key);

  AtletaController state = AtletaController();
  Usuario user;

  @override
  State<ConsultarAtletas> createState() => _ConsultarAtletasState();
}

class _ConsultarAtletasState extends State<ConsultarAtletas> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Lista de Atletas"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (builder) => AtletaTela(state: widget.state, usuarioPermissao: widget.user, atleta: null,)));
              setState(() {});
            }, icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
          future: widget.state.getData(widget.user),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                      itemCount: widget.state.athletes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (builder) => AtletaTela(state: widget.state, usuarioPermissao: widget.user, atleta: widget.state.athletes[index],)));
                            setState(() {});
                          },
                          child: ListTile(
                            title: Text(widget.state.athletes[index].usuario.nome),
                            trailing: const Icon(Icons.arrow_forward_outlined),
                          ),
                        );
                      });
                }
            }
          },
        )
    );
  }
}

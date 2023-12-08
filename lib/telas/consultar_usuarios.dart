import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/telas/usuario.dart';
import 'package:trabalho_faculdade/controllers/usuario_controller.dart';

class ConsultarUsuarios extends StatefulWidget {
  ConsultarUsuarios({Key? key, required this.user}) : super(key: key);

  UsuarioController state = UsuarioController();
  Usuario user;

  @override
  State<ConsultarUsuarios> createState() => _ConsultarUsuariosState();
}

class _ConsultarUsuariosState extends State<ConsultarUsuarios> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Lista de Usuários"),
          centerTitle: true,
          actions: [
            Visibility(
              visible: widget.user.tipo == "administrador",
              child: IconButton(onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (builder) => UsuarioCad(state: widget.state, usuarioPermissao: widget.user, usuarioCad: null)));
                setState(() {});
              }, icon: const Icon(Icons.add)),
            )
          ],
        ),
        body: FutureBuilder(
          future: widget.state.getData(widget.user),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                      itemCount: widget.state.users.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (builder) => UsuarioCad(state: widget.state, usuarioPermissao: widget.user, usuarioCad: widget.state.users[index],)));
                            setState(() {});
                          },
                          child: ListTile(
                            title: Text(widget.state.users[index].nome),
                            subtitle: Text(widget.state.users[index].tipo),
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

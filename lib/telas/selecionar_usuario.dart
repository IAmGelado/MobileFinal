import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/controllers/selecionar_usuario_controller.dart';

class SelecionarUsuario extends StatelessWidget {
  SelecionarUsuario({Key? key, required this.tipo}) : super(key: key);

  int tipo;

  Usuario? userSelected;
  SelecionarUsuarioController state = SelecionarUsuarioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Selecionar usuário"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getFiltro(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            userSelected = state.users[index];
                            Navigator.pop(context, userSelected);
                          },
                          child: ListTile(
                            title: Text(state.users[index].nome),
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

  Future<void> getFiltro() async {
    if (tipo == 1) {
      await state.getUsersAthletesWithout();
    } else if (tipo == 2) {
      await state.getAthletesValidate();
    } else if (tipo == 3) {
      await state.getControlResponsible();
    }
  }
}

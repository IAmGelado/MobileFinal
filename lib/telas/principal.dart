import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/telas/analise_treino.dart';
import 'package:trabalho_faculdade/telas/consultar_atletas.dart';
import 'package:trabalho_faculdade/telas/consultar_treinos.dart';
import 'package:trabalho_faculdade/telas/login.dart';
import 'package:trabalho_faculdade/telas/resultado_treino.dart';
import 'package:trabalho_faculdade/widgets/botao_menu.dart';
import 'package:trabalho_faculdade/telas/consultar_usuarios.dart';
import 'package:trabalho_faculdade/util/pref.dart';

class Principal extends StatelessWidget {
  Principal({Key? key, required this.user}) : super(key: key);

  Usuario user;

  SnackBar snackBar = const SnackBar(
    content: Text('Usuário sem permissão para esse módulo'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("Bem vindo: ${user.nome}", style: const TextStyle(fontSize: 26, color: Colors.black,)),
              ),
              const Divider(),
              ListTile(
                title: const Text('Usuários'),
                trailing: const Icon(Icons.groups),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (builder) => ConsultarUsuarios(user: user)));
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Atletas'),
                trailing: const Icon(Icons.person),
                onTap: () async {
                  if (user.tipo != "administrador") {
                    await Navigator.push(context, MaterialPageRoute(builder: (builder) => ConsultarAtletas(user: user)));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Treinos Atletas'),
                trailing: const Icon(Icons.water),
                onTap: () async {
                  if (user.tipo != "administrador") {
                    await Navigator.push(context, MaterialPageRoute(builder: (builder) => const ConsultarTreinos()));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Análise de Treinos'),
                trailing: const Icon(Icons.trending_up),
                onTap: () async {
                  if (user.tipo == "treinador") {
                    await Navigator.push(context, MaterialPageRoute(builder: (builder) => const AnaliseTreino()));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Resultado de Treino'),
                trailing: const Icon(Icons.newspaper),
                onTap: () async {
                  if (user.tipo == "treinador") {
                    await Navigator.push(context, MaterialPageRoute(builder: (builder) => const ResultadoTreino()));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Sair do Aplicativo'),
                trailing: const Icon(Icons.exit_to_app),
                onTap: () async {
                  await Pref().remove('user');
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Login()));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text("Bem vindo: ${user.nome}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOption(
                  enabled: true,
                  title: "Usuários",
                  icon: Icons.groups,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => ConsultarUsuarios(user: user)));
                  }),
              ButtonOption(
                  enabled: user.tipo != "administrador",
                  title: "Atletas",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => ConsultarAtletas(user: user)));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOption(
                  enabled: user.tipo != "administrador",
                  title: "Treinos dos Atletas",
                  icon: Icons.water,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const ConsultarTreinos()));
                  }),
              ButtonOption(
                  enabled: user.tipo == "treinador",
                  title: "Análise dos treinos",
                  icon: Icons.trending_up,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const AnaliseTreino()));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOption(
                  enabled: user.tipo == "treinador",
                  title: "Resultado de treino",
                  icon: Icons.newspaper,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => ResultadoTreino()));
                  }),
              ButtonOption(
                  enabled: true,
                  title: "Sair do aplicativo",
                  icon: Icons.exit_to_app,
                  onTap: () async {
                    await Pref().remove('user');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Login()));
                  })
            ],
          )
        ],
      ),
    );
  }
}

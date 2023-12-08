import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/controllers/usuario_controller.dart';
import 'package:trabalho_faculdade/util/util.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/checkbox_custom.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class UsuarioCad extends StatefulWidget {
  UsuarioCad({Key? key, required this.state, required this.usuarioPermissao, this.usuarioCad})
      : super(key: key);

  UsuarioController state;
  Usuario usuarioPermissao;
  Usuario? usuarioCad;

  @override
  State<UsuarioCad> createState() => _UsuarioCadState();
}

class _UsuarioCadState extends State<UsuarioCad> {
  bool update = false;

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.usuarioCad != null) {
      update = true;
      controllerName.text = widget.usuarioCad!.nome;
      controllerEmail.text = widget.usuarioCad!.email;
    } else {
      widget.usuarioCad = Usuario(idUsuario: "", nome: "", email: "", senha: "", tipo: "", ativo: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Usuário"),
          centerTitle: true,
        ),
        body: widget.state.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70),
                        TextFieldCustom(
                            readOnly: widget.usuarioPermissao.tipo != "administrador",
                            text: "Nome",
                            hint: "Informe o seu nome",
                            inputType: TextInputType.name,
                            controller: controllerName,
                            onValidate: (value) {
                              if (controllerName.text.isEmpty) {
                                return 'Nome inválido ou vazio';
                              } else {
                                widget.usuarioCad!.nome = controllerName.text;
                              }
                            },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: !update,
                          child: TextFieldCustom(
                              text: "Email",
                              hint: "Informe o seu email",
                              inputType: TextInputType.emailAddress,
                              controller: controllerEmail,
                              onValidate: (value) {
                                if ((controllerEmail.text.isEmpty ||
                                    !Util.validateEmail(controllerEmail.text)) &&
                                    !update) {
                                  return 'Email inválido ou vazio';
                                } else {
                                  widget.usuarioCad!.email = controllerEmail.text;
                                }
                              },
                              ),
                        ),
                        Visibility(
                          visible: !update,
                          child: const SizedBox(
                            height: 30,
                          ),
                        ),
                        Visibility(
                          visible: !update,
                          child: TextFieldCustom(
                              text: "Senha (mínimo 6 caracteres)",
                              hint: "Informe a sua senha",
                              inputType: TextInputType.text,
                              isPassword: true,
                              controller: controllerPassword,
                              onValidate: (value) {
                                if ((controllerPassword.text.isEmpty ||
                                    controllerPassword.text.length <= 5) &&
                                    !update) {
                                  return 'Email inválida ou vazia';
                                } else {
                                  widget.usuarioCad!.senha = controllerPassword.text;
                                }
                              },
                              ),
                        ),
                        Visibility(
                          visible: !update,
                          child: const SizedBox(
                            height: 30,
                          ),
                        ),
                        Text("Perfil", style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxCustom(
                                disabled: widget.usuarioPermissao.tipo != "administrador",
                                title: "Administrador",
                                onPressed: () {
                                  setState(() {
                                    widget.usuarioCad!.tipo = 'administrador';
                                  });
                                },
                                isCheck: widget.usuarioCad!.tipo == 'administrador'),
                            const SizedBox(
                              height: 10,
                            ),
                            CheckboxCustom(
                                disabled: widget.usuarioPermissao.tipo != "administrador",
                                title: "Atleta",
                                onPressed: () {
                                  setState(() {
                                    widget.usuarioCad!.tipo = 'atleta';
                                  });
                                },
                                isCheck: widget.usuarioCad!.tipo == 'atleta'),
                            const SizedBox(
                              height: 10,
                            ),
                            CheckboxCustom(
                                disabled: widget.usuarioPermissao.tipo != "administrador",
                                title: "Treinador",
                                onPressed: () {
                                  setState(() {
                                    widget.usuarioCad!.tipo = 'treinador';
                                  });
                                },
                                isCheck: widget.usuarioCad!.tipo == 'treinador'),
                          ],
                        ),
                        const SizedBox(height: 80),
                        Visibility(
                          visible: widget.usuarioPermissao.tipo == "administrador",
                          child: ButtonCustom(
                              title: "Salvar",
                              onPressed: () async {
                                _formKey.currentState!.save();
                                if(_formKey.currentState!.validate()) {

                                  if (widget.usuarioCad!.tipo == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Usuário salvo com sucesso'),
                                    ));
                                  } else {
                                    setState(() {
                                      widget.state.isLoading = true;
                                    });

                                    bool res = await widget.state.saveUser(widget.usuarioCad!);

                                    setState(() {
                                      widget.state.isLoading = false;
                                    });

                                    if (res) {
                                      if (res) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text('Usuário salvo com sucesso'),
                                        ));
                                      }
                                      Navigator.pop(context);
                                    }
                                  }
                                };
                              }),
                        ),
                        Visibility(
                          visible: update && widget.usuarioPermissao.tipo == "administrador",
                          child: ButtonCustom(
                              title: "Excluir",
                              onPressed: () async {
                                setState(() {
                                  widget.state.isLoading = true;
                                });

                                bool res = await widget.state.excluir(widget.usuarioCad!);

                                setState(() {
                                  widget.state.isLoading = false;
                                });

                                if (res) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Usuário excluído com sucesso'),
                                  ));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Falha ao excluir usuário'),
                                  ));
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
            ));
  }
}

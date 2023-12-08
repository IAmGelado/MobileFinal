import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/controllers/recuperacao_senha_controller.dart';
import 'package:trabalho_faculdade/util/colors.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class RecoverPasswordView extends StatefulWidget {
  const RecoverPasswordView({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordView> createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends State<RecoverPasswordView> {
  RecuperacaoSenhaController state = RecuperacaoSenhaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recuperação de senha"),
          centerTitle: true,
          elevation: 0,
        ),
        body: state.isLoading ? const Center(child: CircularProgressIndicator(),) : Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Coloque seu email abaixo, para receber o link de recuperação",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: MyColors.neutralText),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFieldCustom(
                      text: "Email",
                      hint: "Informe seu email",
                      inputType: TextInputType.emailAddress,
                      controller: controllerEmail,
                      onValidate: (value) {
                        if (controllerEmail.text.isEmpty) {
                          return "Email em branco ou inválido";
                        }
                      },),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(height: 80),
                  state.isLoading ? const Center(
                    child: CircularProgressIndicator(),
                  ) : ButtonCustom(
                      title: "Enviar Link",
                      onPressed: () async {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            state.isLoading = true;
                          });
                          await state.enviarLink(controllerEmail.text);
                          setState(() {
                            state.isLoading = false;
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
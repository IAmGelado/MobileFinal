import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/controllers/login_controller.dart';
import 'package:trabalho_faculdade/telas/principal.dart';
import 'package:trabalho_faculdade/telas/recuperacao_senha.dart';
import 'package:trabalho_faculdade/util/assets.dart';
import 'package:trabalho_faculdade/util/colors.dart';
import 'package:trabalho_faculdade/util/pref.dart';
import 'package:trabalho_faculdade/util/util.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';


class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  LoginController state = LoginController();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController(text: "teste@teste.com");
  final TextEditingController controllerPassword = TextEditingController(text: "123456");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.state.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Image.asset(Assets.logo,
                              height: 200, width: 200)),
                      const SizedBox(height: 90),
                      TextFieldCustom(
                          hint: "Informe o seu email",
                          text: "Email",
                          inputType: TextInputType.emailAddress,
                          controller: controllerEmail,
                          onValidate: (value) {
                            if (controllerEmail.text.isEmpty || !Util.validateEmail(controllerEmail.text)) {
                              return "Email inválido ou vazio";
                            }
                          },
                          ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFieldCustom(
                          text: "Senha",
                          hint: "Informe sua senha",
                          inputType: TextInputType.text,
                          isPassword: true,
                          controller: controllerPassword,
                          onValidate: (value) {
                            if (controllerPassword.text.isEmpty) {
                              return "Senha inválida ou vazia";
                            }
                          },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => const RecoverPasswordView()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Esqueci a senha",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      ButtonCustom(
                          title: "Entrar",
                          onPressed: () async {
                            _formKey.currentState!.save();

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                widget.state.isLoading = true;
                              });

                              if (await widget.state.onLogin(controllerEmail.text, controllerPassword.text)) {
                                var user = await Pref().getUser();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => Principal(
                                          user: user!,
                                        )));
                              }

                              setState(() {
                                widget.state.isLoading = false;
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

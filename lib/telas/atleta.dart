import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_faculdade/entidades/atleta.dart';
import 'package:trabalho_faculdade/entidades/telefone.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/listas/categorias_lista.dart';
import 'package:trabalho_faculdade/listas/tipos_telefone_lista.dart';
import 'package:trabalho_faculdade/listas/provas_lista.dart';
import 'package:trabalho_faculdade/controllers/atleta_controller.dart';
import 'package:trabalho_faculdade/telas/selecionar_usuario.dart';
import 'package:trabalho_faculdade/util/colors.dart';
import 'package:trabalho_faculdade/util/masks.dart';
import 'package:trabalho_faculdade/util/util.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/checkbox_custom.dart';
import 'package:trabalho_faculdade/widgets/field_file.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class AtletaTela extends StatefulWidget {
  AtletaTela({Key? key, required this.state, required this.usuarioPermissao, this.atleta})
      : super(key: key);

  AtletaController state;
  Usuario usuarioPermissao;
  Atleta? atleta;

  @override
  State<AtletaTela> createState() => _AtletaTelaState();
}

class _AtletaTelaState extends State<AtletaTela> {
  List<String> stylesUser = [];
  List<String> categoryUser = [];
  bool update = false;
  bool validacaoFeita = false;
  List<String> alergias = [];
  List<String> estilos = [];
  List<String> provas = [];
  List<Telefone> telefones = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerUsuario = TextEditingController();
  final TextEditingController controllerDataNascimento = TextEditingController();
  final TextEditingController controllerLocalNascimento = TextEditingController();
  final TextEditingController controllerNacionalidade = TextEditingController();
  final TextEditingController controllerRg = TextEditingController();
  final TextEditingController controllerCpf = TextEditingController();
  final TextEditingController controllerEnderecoCompleto = TextEditingController();
  final TextEditingController controllerNomeMae = TextEditingController();
  final TextEditingController controllerNomePai = TextEditingController();
  final TextEditingController controllerClubeOrigem = TextEditingController();
  final TextEditingController controllerLocalTrabalho = TextEditingController();
  final TextEditingController controllerConvenioMedico = TextEditingController();
  final TextEditingController controllerAlergias = TextEditingController();
  final TextEditingController controllerTelefone = TextEditingController();


  @override
  void initState() {
    if (widget.atleta != null) {
      update = true;
      controllerUsuario.text = widget.atleta!.usuario.nome;
      controllerDataNascimento.text = widget.atleta!.dataNascimento;
      controllerLocalNascimento.text = widget.atleta!.localNascimento;
      controllerNacionalidade.text = widget.atleta!.nacionalidade;
      controllerRg.text = widget.atleta!.rg;
      controllerCpf.text = widget.atleta!.cpf;
      controllerEnderecoCompleto.text = widget.atleta!.enderecoCompleto;
      controllerNomeMae.text = widget.atleta!.nomeMae;
      controllerNomePai.text = widget.atleta!.nomePai;
      controllerClubeOrigem.text = widget.atleta!.clubeOrigem;
      controllerConvenioMedico.text = widget.atleta!.convenioMedico;
      controllerLocalTrabalho.text = widget.atleta!.localTrabalho;

      widget.state.pathAtestadoMedico = widget.atleta!.urlComprovanteEndereco;
      widget.state.pathRg = widget.atleta!.urlArquivoRg;
      widget.state.pathCPf = widget.atleta!.urlArquivoRg;
      widget.state.pathComprovanteEndereco = widget.atleta!.urlComprovanteEndereco;
      widget.state.pathFoto = widget.atleta!.urlFoto3X4;
      widget.state.pathRegulamento = widget.atleta!.urlRegulamento;

      alergias.clear();
      provas.clear();
      estilos.clear();
      telefones.clear();

      alergias.addAll(widget.atleta!.alergias);
      provas.addAll(widget.atleta!.provas);
      estilos.addAll(widget.atleta!.estilos);
      telefones.addAll(widget.atleta!.telefones);
    } else {
      widget.atleta = Atleta(atletaID: "", usuario: Usuario(idUsuario: "", tipo: "", nome: "", senha: "", email: "", ativo: true),
                             dataNascimento: "", localNascimento: "", nacionalidade: "", rg: "", cpf: "", sexo: "",
                             enderecoCompleto: "", nomeMae: "", nomePai: "", clubeOrigem: "", localTrabalho: "",
                             convenioMedico: "", alergias: [], estilos: [], provas: [], telefones: [],
                             urlAtestadoMedico: "", urlArquivoRg: "", urlArquivoCpf: "", urlComprovanteEndereco: "",
                             urlFoto3X4: "", urlRegulamento: "", ativo: true, validar: false);

      widget.state.pathAtestadoMedico = "";
      widget.state.pathRg = "";
      widget.state.pathCPf = "";
      widget.state.pathComprovanteEndereco = "";
      widget.state.pathFoto = "";
      widget.state.pathRegulamento = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stylesUser.clear();
    categoryUser.clear();

    stylesUser.addAll(estilosLista);
    categoryUser.addAll(provasLista);

    stylesUser.removeAt(0);
    categoryUser.removeAt(0);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Atheta"),
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
                            text: "Usuário",
                            hint: "Informe o usuário",
                            inputType: TextInputType.name,
                            readOnly: true,
                            onTap: () async {
                              var result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelecionarUsuario(tipo: 1)));
                              if (result != null) {
                                widget.atleta!.usuario = result;
                                controllerUsuario.text = result.nome;
                               }
                            },
                            controller: controllerUsuario,
                            onValidate: (value) {
                              if (controllerUsuario.text.isEmpty) {
                                return 'Usuário inválido ou vazio';
                              }
                            },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            onTap: () async {
                              var selectedDate;

                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.parse("2000-01-01"),
                                lastDate: DateTime.parse("2050-01-01"),
                                locale: const Locale('pt', 'BR'),
                                confirmText: 'Confirmar',
                                cancelText: 'Cancelar',
                              );

                              if (selectedDate != null) {
                                selectedDate = DateFormat('dd/MM/yyyy')
                                    .format(selectedDate);

                                setState(() {
                                  controllerDataNascimento.text = selectedDate;
                                });
                              }
                            },
                            readOnly: true,
                            hint: "Quando você nasceu",
                            text: "Data de nascimento",
                            inputType: TextInputType.number,
                            mask: maskDateFormatter,
                            isPassword: false,
                            controller: controllerDataNascimento,
                            onValidate: (value) {
                              if (controllerDataNascimento.text.isEmpty) {
                                return 'Data de Nascimento inválida ou vazia';
                              } else {
                                widget.atleta!.dataNascimento = controllerDataNascimento.text;
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Naturalidade",
                            hint: "Onde você nasceu",
                            inputType: TextInputType.text,
                            isPassword: false,
                            onValidate: (value) {
                              if (controllerLocalNascimento.text.isEmpty) {
                                return 'Naturalidade inválida ou vazia';
                              } else {
                                widget.atleta!.localNascimento = controllerLocalNascimento.text;
                              }
                            },
                            controller: controllerLocalNascimento),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            hint: "Sua nacionalidade",
                            text: "Nacionalidade",
                            inputType: TextInputType.text,
                            isPassword: false,
                            onValidate: (value) {
                              if (controllerNacionalidade.text.isEmpty) {
                                return 'Nacionalidade inválida ou vazia';
                              } else {
                                widget.atleta!.nacionalidade = controllerNacionalidade.text;
                              }
                            },
                            controller: controllerNacionalidade),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "RG",
                            hint: "Seu RG",
                            inputType: TextInputType.number,
                            isPassword: false,
                            controller: controllerRg,
                            onValidate: (value) {
                              if (controllerRg.text.isEmpty) {
                                return 'RG inválido ou vazio';
                              } else {
                                widget.atleta!.rg = controllerRg.text;
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "CPF",
                            hint: "Seu CPF",
                            inputType: TextInputType.number,
                            mask: maskCPFFormatter,
                            isPassword: false,
                            controller: controllerCpf,
                            onValidate: (value) {
                              if (controllerCpf.text.isEmpty || !Util().validateCPF(controllerCpf.text)) {
                                return 'CPF inválido ou vazio';
                              } else {
                                widget.atleta!.cpf = controllerCpf.text;
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Sexo",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxCustom(
                                title: "Masculino",
                                onPressed: () {
                                  setState(() {
                                    widget.atleta!.sexo = 'Masculino';
                                  });
                                },
                                isCheck: widget.atleta!.sexo == 'Masculino'),
                            const SizedBox(
                              height: 10,
                            ),
                            CheckboxCustom(
                                title: "Feminino",
                                onPressed: () {
                                  setState(() {
                                    widget.atleta!.sexo = 'Feminino';
                                  });
                                },
                                isCheck: widget.atleta!.sexo == 'Feminino'),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Endereço completo",
                            hint: "Informe seu endereço",
                            inputType: TextInputType.text,
                            isPassword: false,
                            controller: controllerEnderecoCompleto,
                            onValidate: (value) {
                              if (controllerEnderecoCompleto.text.isEmpty) {
                                return 'Endereço inválido ou vazio';
                              } else {
                                widget.atleta!.enderecoCompleto = controllerEnderecoCompleto.text;
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Nome da mãe",
                            hint: "Informe o nome da sua mãe",
                            inputType: TextInputType.name,
                            isPassword: false,
                            onValidate: (value) {
                              widget.atleta!.nomeMae = value ?? "";
                            },
                            controller: controllerNomeMae),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Nome do pai",
                            hint: "Informe o nome do seu pai",
                            inputType: TextInputType.name,
                            isPassword: false,
                            onValidate: (value) {
                              widget.atleta!.nomePai = value ?? "";
                            },
                            controller: controllerNomePai),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Clube de Origem",
                            hint: "Seu clube de origem",
                            inputType: TextInputType.text,
                            isPassword: false,
                            onValidate: (value) {
                              widget.atleta!.clubeOrigem = value ?? "";
                            },
                            controller: controllerClubeOrigem),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Local de trabalho",
                            hint: "Onde você trabalha",
                            inputType: TextInputType.text,
                            isPassword: false,
                            onValidate: (value) {
                              widget.atleta!.localTrabalho = value ?? "";
                            },
                            controller: controllerLocalTrabalho),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Convênio médico",
                            hint: "Qual é seu convênio médico",
                            inputType: TextInputType.text,
                            isPassword: false,
                            controller: controllerConvenioMedico,
                            onValidate: (value) {
                              if (controllerConvenioMedico.text.isEmpty) {
                                return 'Convênio médico inválido ou vazio';
                              } else {
                                widget.atleta!.convenioMedico = controllerConvenioMedico.text;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldCustom(
                            text: "Alergia",
                            hint:
                            "A cada alergia informada, aperte o botão +",
                            inputType: TextInputType.text,
                            isPassword: false,
                            controller: controllerAlergias,
                            getColorValidator: MyColors.gray,
                            onTapAdd: () {
                              if (controllerAlergias.text.isNotEmpty) {
                                setState(() {
                                  alergias.add(
                                      controllerAlergias.text);
                                  controllerAlergias.clear();
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Informe uma ou mais alergias'),
                                ));
                              }
                            }),
                        const SizedBox(height: 10,),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: alergias.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      alergias[i],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            alergias.removeAt(i);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                            text: "Telefone",
                            hint:
                            "A cada telefone informado, aperte o botão +",
                            inputType: TextInputType.number,
                            isPassword: false,
                            mask: maskPhoneFormatter,
                            controller: controllerTelefone,
                            getColorValidator: MyColors.gray,
                            onTapAdd: () {
                              if (controllerTelefone.text != "" &&
                                  widget.state.phone.tipo != "") {
                                setState(() {
                                  widget.state.phone.telefone = controllerTelefone.text;
                                  telefones.add(widget.state.phone);

                                  controllerTelefone.clear();
                                  widget.state.phone =
                                      Telefone(telefone: "", tipo: "");
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Preencha as informações do telefone'),
                                ));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tipoTelefone.length,
                            itemBuilder: (context, i) {
                              return CheckboxCustom(
                                  title: tipoTelefone[i],
                                  onPressed: () {
                                    setState(() {
                                      widget.state.phone.tipo =
                                      tipoTelefone[i];
                                    });
                                  },
                                  isCheck: widget.state.phone.tipo ==
                                      tipoTelefone[i]);
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: telefones.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      telefones[i].telefone,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      telefones[i].tipo,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            telefones.removeAt(i);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Estilos",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: stylesUser.length,
                            itemBuilder: (context, i) {
                              return CheckboxCustom(
                                  title: stylesUser[i],
                                  onPressed: () {
                                    setState(() {
                                      if (estilos.contains(stylesUser[i])) {
                                        estilos.remove(stylesUser[i]);
                                      } else {
                                        estilos.add(stylesUser[i]);
                                      }
                                    });
                                  },
                                  isCheck: estilos.contains(stylesUser[i]));
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Provas",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categoryUser.length,
                            itemBuilder: (context, i) {
                              return CheckboxCustom(
                                  title: categoryUser[i],
                                  onPressed: () {
                                    setState(() {
                                      if (provas.contains(categoryUser[i])) {
                                        provas.remove(categoryUser[i]);
                                      } else {
                                        provas.add(categoryUser[i]);
                                      }
                                    });
                                  },
                                  isCheck: provas.contains(categoryUser[i]));
                            }),
                        FieldFile(
                            title: "Atestado médico admissional",
                            onTap: () async {
                              await widget.state.setMedicalCertificate();
                              setState(() {});
                            },
                            text: widget.state.pathAtestadoMedico,
                            color: widget.state.pathAtestadoMedico.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        FieldFile(
                            title: "Comprovante RG",
                            onTap: () async {
                              await widget.state.setFileRg();
                              setState(() {});
                            },
                            text: widget.state.pathRg,
                            color: widget.state.pathRg.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        FieldFile(
                            title: "Comprovante CPF",
                            onTap: () async {
                              await widget.state.setFileCpf();
                              setState(() {});
                            },
                            text: widget.state.pathCPf,
                            color: widget.state.pathCPf.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        FieldFile(
                            title: "Comprovante de residência",
                            onTap: () async {
                              await widget.state.setProofOfAddress();
                              setState(() {});
                            },
                            text: widget.state.pathComprovanteEndereco,
                            color: widget.state.pathComprovanteEndereco.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        FieldFile(
                            title: "Foto 3X4",
                            onTap: () async {
                              await widget.state.setPhoto3X4();
                              setState(() {});
                            },
                            text: widget.state.pathFoto,
                            color: widget.state.pathFoto.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        FieldFile(
                            title: "Regulamento assinado",
                            onTap: () async {
                              await widget.state.setRegulation();
                              setState(() {});
                            },
                            text: widget.state.pathRegulamento,
                            color: widget.state.pathRegulamento.isEmpty && validacaoFeita
                                ? Colors.red
                                : Colors.black),
                        const SizedBox(height: 30,),
                        Visibility(
                          visible: widget.usuarioPermissao.tipo == "treinador",
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Validação do treinador",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Visibility(
                          visible: widget.usuarioPermissao.tipo == "treinador",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CheckboxCustom(
                                  title: "Atleta validado",
                                  onPressed: () {
                                    setState(() {
                                      widget.atleta!.validar = !widget.atleta!.validar;
                                    });
                                  },
                                  isCheck: widget.atleta!.validar),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        ButtonCustom(
                            title: "Salvar",
                            onPressed: () async {
                              _formKey.currentState!.save();
                              setState(() {
                                validacaoFeita = true;
                              });

                              if (_formKey.currentState!.validate()) {
                                if (telefones.where((e) => e.tipo == "Celular").isEmpty ||
                                    telefones.where((e) => e.tipo == "Emergência").isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Informe pelo menos um celular e um número de emergência'),
                                  ));
                              } else if (estilos.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Informe um ou mais estilos'),
                                  ));
                              } else if (provas.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Informe uma ou mais provas'),
                                  ));
                              } else {
                                  setState(() {
                                    widget.state.isLoading = true;
                                  });

                                  widget.atleta!.estilos = estilos;
                                  widget.atleta!.provas = provas;
                                  widget.atleta!.alergias = alergias;
                                  widget.atleta!.telefones = telefones;

                                  bool res = await widget.state.salvar(widget.atleta!);

                                  setState(() {
                                    widget.state.isLoading = false;
                                  });

                                  if (res) {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            }),
                        Visibility(
                          visible: update,
                          child: ButtonCustom(
                              title: "Excluir",
                              onPressed: () async {
                                setState(() {
                                  widget.state.isLoading = true;
                                });

                                bool res = await widget.state.deletar(widget.atleta!);

                                setState(() {
                                  widget.state.isLoading = false;
                                });

                                if (res) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Atleta excluído com sucesso'),
                                  ));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Falha ao excluir atleta'),
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

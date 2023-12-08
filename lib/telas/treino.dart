import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_faculdade/controllers/treino_controller.dart';
import 'package:trabalho_faculdade/entidades/atleta.dart';
import 'package:trabalho_faculdade/entidades/tempo_treino.dart';
import 'package:trabalho_faculdade/entidades/treino.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';
import 'package:trabalho_faculdade/listas/categorias_lista.dart';
import 'package:trabalho_faculdade/listas/provas_lista.dart';
import 'package:trabalho_faculdade/telas/selecionar_usuario.dart';
import 'package:trabalho_faculdade/util/timer.dart';
import 'package:trabalho_faculdade/util/util.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/checkbox_custom.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class TreinoTela extends StatefulWidget {
  TreinoTela({Key? key, required this.state, this.treino}) : super(key: key);
  TreinoController state;
  Treino? treino;

  @override
  State<TreinoTela> createState() => _TreinoTelaState();
}

class _TreinoTelaState extends State<TreinoTela> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRunning = false;
  bool update = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerNumero = TextEditingController();
  final TextEditingController controllerAtleta = TextEditingController();
  final TextEditingController controllerData = TextEditingController();
  final TextEditingController controllerComeco = TextEditingController();
  final TextEditingController controllerFim = TextEditingController();
  final TextEditingController controllerResponsavel = TextEditingController();
  final TextEditingController controllerUltimaVolta = TextEditingController();

  String estiloSelecionado = '';
  String provaSelecionada = '';

  List<String> estilosAtleta = [];
  List<String> provasAtleta = [];

  List<String> estilosTreino = [];
  List<String> provasTraining = [];

  List<TempoTreino> timers = [];
  List<int> timerInSeconds = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 1), _updateTimer);

    if (widget.treino != null) {
      update = true;
      controllerAtleta.text = widget.treino!.atleta.nome;
      estiloSelecionado = widget.treino!.estilo;
      provaSelecionada = widget.treino!.prova;
      controllerNumero.text = widget.treino!.numero;
      controllerData.text = widget.treino!.data;
      controllerComeco.text = widget.treino!.frequenciaInicio.toString();
      controllerFim.text = widget.treino!.frequenciaFim.toString();
      controllerResponsavel.text = widget.treino!.responsavelControle.nome;
      controllerUltimaVolta.text = widget.treino!.ultimaVolta.toString();

      provasAtleta.clear();
      estilosAtleta.clear();

      for (var time in widget.treino!.tempoPor100) {

        var totalMilliseconds = time;
        var totalSeconds = totalMilliseconds ~/ 1000;
        var seconds = totalSeconds % 60;
        var minutes = (totalSeconds ~/ 60) % 60;
        var milliseconds = totalMilliseconds % 1000;

        timers.add(TempoTreino(minutos: minutes.toString().padLeft(2, '0'), segundos: seconds.toString().padLeft(2, '0'), milisegundos: milliseconds.toString().padLeft(2, '0')));
      }

    } else {
      widget.treino = Treino(
          id: "",
          estilo: "",
          prova: "",
          numero: "",
          atleta: Usuario(idUsuario: "", nome: "", email: "", senha: "", tipo: "", ativo: true),
          data: "",
          frequenciaInicio: 0,
          frequenciaFim: 0,
          responsavelControle:  Usuario(idUsuario: "", nome: "", email: "", senha: "", tipo: "", ativo: true),
          ultimaVolta: 0,
          ultimaVoltaConcluida: false,
          tempoPor100: [],
          ativo: true
      );
    }
  }

  void _updateTimer(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final minutes = (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (_stopwatch.elapsed.inMilliseconds % 60).toString().padLeft(2, '0');


    estilosTreino.addAll(estilosLista);
    provasTraining.addAll(provasLista);

    estilosTreino.removeAt(0);
    provasTraining.removeAt(0);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Treino"),
          centerTitle: true,
          elevation: 0,
        ),
        body: widget.state.isLoading ? const Center(child: CircularProgressIndicator(),) : Form(
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
                      controller: controllerAtleta,
                      onTap: () async {
                        var result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelecionarUsuario(tipo: 2,)));
                          if (result != null) {
                            controllerAtleta.text = result.nome;
                            widget.treino!.atleta = result;

                            var res = await FirebaseFirestore.instance.collection('atletas').where('ativo', isEqualTo: true).where('validar', isEqualTo: true).get();
                            var docs = res.docs;

                            for (var doc in docs) {
                              var obj =  Atleta.fromSnapshot(doc);

                              if (obj.usuario.idUsuario == widget.treino!.atleta.idUsuario) {
                                provasAtleta.clear();
                                estilosAtleta.clear();
                                provasAtleta.addAll(obj.provas);
                                estilosAtleta.addAll(obj.estilos);

                                if (widget.treino != null) {
                                  estiloSelecionado = widget.treino!.estilo;
                                  provaSelecionada = widget.treino!.prova;
                                } else {
                                  estiloSelecionado = "";
                                  provaSelecionada = "";
                                }
                              }
                            }
                            setState(() {});
                        }
                      },
                      readOnly: true,
                      text: "Atleta",
                      hint: "Qual é o atleta do treino?",
                      inputType: TextInputType.text,
                       onValidate: (value) {
                        if (controllerAtleta.text.isEmpty) {
                          return "Atleta inválido ou não informado";
                        } else {

                        }
                       },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Estilo", style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 50,
                    width: double.infinity,
                    child: DropdownButton<String>(
                      hint: const Text("Informe um estilo"),
                      value: estiloSelecionado == "" ? null : estiloSelecionado,
                      onChanged: (newValue) {
                        estiloSelecionado = newValue ?? "";
                        widget.treino!.estilo == estiloSelecionado;
                        setState(() {});
                      },
                      items: estilosAtleta
                          .map<DropdownMenuItem<String>>((String style) {
                        return DropdownMenuItem<String>(
                          value: style,
                          child: Text(style),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Categoria:", style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 50,
                    width: double.infinity,
                    child: DropdownButton<String>(
                      hint: const Text("Informe uma prova"),
                      value: provaSelecionada == "" ? null : provaSelecionada,
                      onChanged: (newValue) {
                        provaSelecionada = newValue ?? "";
                        widget.treino!.prova = provaSelecionada;
                        setState(() {});
                      },
                      items: provasAtleta
                          .map<DropdownMenuItem<String>>((String style) {
                        return DropdownMenuItem<String>(
                          value: style,
                          child: Text(style),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      controller: controllerNumero,
                      text: "Número",
                      hint: "Informe o número do treino",
                      inputType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                      onValidate: (value) {
                        if (controllerNumero.text.isEmpty || !Util().isInteger(controllerNumero.text)) {
                          return 'Número inválido ou não informado';
                        } else {
                          widget.treino!.numero = controllerNumero.text;
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      controller: controllerData,
                      hint: "Quando aconteceu",
                      text: "Data",
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
                          controllerData.text = selectedDate;
                        }
                      },
                      inputType: TextInputType.number,
                      onValidate: (value) {
                        if (controllerData.text.isEmpty) {
                          return 'Data inválida ou não informada';
                        } else {
                          widget.treino!.data = controllerData.text;
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      controller: controllerComeco,
                      text: "Frequência cardíaca no ínicio",
                      hint: "Frequência no ínicio do treino",
                      inputType: TextInputType.number,
                      onValidate: (value) {
                        if (controllerComeco.text.isEmpty || !Util().isDecimal(controllerComeco.text)) {
                          return 'Frequência ou não informada';
                        } else {
                          widget.treino!.frequenciaInicio = double.parse(controllerComeco.text);
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      controller: controllerFim,
                      text: "Frequência cardíaca no final",
                      hint: "Frequência no final do treino",
                      inputType: TextInputType.number,
                      onValidate: (value) {
                        if (controllerFim.text.isEmpty || !Util().isDecimal(controllerFim.text)) {
                          return 'Frequência ou não informada';
                        } else {
                          widget.treino!.frequenciaFim = double.parse(controllerFim.text);
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      onTap: () async {
                        if (widget.treino!.atleta.idUsuario == "") {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Informe o atleta'),
                          ));
                        } else {
                          var result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelecionarUsuario(tipo: 2)));

                          if (result.idUsuario == 10) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('O responsável pelo treino e o atleta, não podem ser iguais'),
                            ));
                          } else {
                            if (result != null) {
                              setState(() {
                                controllerResponsavel.text = result.nome;
                                widget.treino!.responsavelControle = result;
                              });
                            }
                          }
                        }
                      },
                      readOnly: true,
                      controller: controllerResponsavel,
                      hint: "Responsável pelo controle do tempo",
                      text: "Responsável",
                      inputType: TextInputType.text,
                      onValidate: (value) {
                        if (controllerResponsavel.text.isEmpty) {
                          return 'Responsável não infomado ou inválido';
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldCustom(
                      controller: controllerUltimaVolta,
                      text: "Quantidade metros última volta",
                      hint: "Informe o quantidade",
                      inputType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                      onValidate: (value) {
                        if (controllerUltimaVolta.text.isEmpty || !Util().isDecimal(controllerUltimaVolta.text)) {
                          return 'Quantidade não informada ou inválida';
                        } else {
                          widget.treino!.ultimaVolta = double.parse(controllerUltimaVolta.text);
                        }
                      }),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CheckboxCustom(
                          title: "A última volta foi completa?",
                          onPressed: () {
                            setState(() {
                              widget.treino!.ultimaVoltaConcluida = !widget.treino!.ultimaVoltaConcluida;
                            });
                          },
                          isCheck: widget.treino!.ultimaVoltaConcluida),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Tempos a cada 100 metros", style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: timers.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tempo: ${i + 1}: ${timers[i].minutos}:${timers[i].segundos}:${timers[i].milisegundos}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(onPressed: () {
                                setState(() {
                                  timers.removeAt(i);
                                });
                              }, icon: const Icon(Icons.close, color: Colors.red,))
                            ],
                          ),
                        );
                      }),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$minutes:$seconds:$milliseconds',
                        style: const TextStyle(fontSize: 22.0),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_stopwatch.isRunning) {
                                _stopwatch.stop();
                              } else {
                                _stopwatch.start();
                              }
                              setState(() {
                                _isRunning = !_isRunning;
                              });
                            },
                            child: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (milliseconds == "00" && minutes == "00" && seconds == "00") {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Não é possível adicionar tempo zerado'),
                                ));
                              } else {
                                setState(() {
                                  TempoTreino timer = TempoTreino(
                                      minutos: minutes, segundos: seconds, milisegundos: milliseconds);

                                  timers.add(timer);
                                });
                              }
                            },
                            child: const Text('Adicionar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  ButtonCustom(
                      title: "Salvar",
                      onPressed: () async {
                        _formKey.currentState!.save();

                        if (_formKey.currentState!.validate()) {
                          if (timers.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Informe os tempos'),
                            ));
                          } else {
                            timerInSeconds.clear();
                            for (var time in timers) {
                              timerInSeconds.add(int.parse(getStringToTime('${time.minutos}:${time.segundos}:${time.milisegundos}')));
                            }

                            widget.treino!.estilo = estiloSelecionado;
                            widget.treino!.prova = provaSelecionada;
                            widget.treino!.tempoPor100 = timerInSeconds;

                            setState(() {
                              widget.state.isLoading = true;
                            });

                            bool res = await widget.state.salvar(widget.treino!);

                            setState(() {
                              widget.state.isLoading = false;
                            });

                            if (res) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Treino salvo com sucesso'),
                              ));

                              Navigator.pop(context);
                            }
                          }
                        }
                      }),
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

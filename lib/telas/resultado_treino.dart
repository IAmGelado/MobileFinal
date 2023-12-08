import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_faculdade/controllers/resultado_treino_controller.dart';
import 'package:trabalho_faculdade/telas/selecionar_usuario.dart';
import 'package:trabalho_faculdade/util/colors.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/card_treino.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class ResultadoTreino extends StatefulWidget {
  const ResultadoTreino({Key? key}) : super(key: key);

  @override
  State<ResultadoTreino> createState() => _ResultadoTreinoState();
}

class _ResultadoTreinoState extends State<ResultadoTreino> {
  ResultadoTreinoController state = ResultadoTreinoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Resultado de Treino"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
            future: state.getData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView(
                      children: [
                        const SizedBox(height: 30,),
                        TextFieldCustom(
                            controller: state.controllerAthlete,
                            onTap: () async {
                              var result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelecionarUsuario(tipo: 2)));
                              if (result != null) {
                                state.setAthlete(result);
                              }
                            },
                            readOnly: true,
                            text: "Atleta (opcional)",
                            hint: "Informe o atheta",
                            inputType: TextInputType.text,
                            getColorValidator: MyColors.gray),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextFieldCustom(
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
                                      selectedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
                                      state.controllerDateInit.text = selectedDate;
                                    }
                                  },
                                  controller: state.controllerDateInit,
                                  readOnly: true,
                                  text: "Data Inicial",
                                  hint: "",
                                  inputType: TextInputType.number,
                                  getColorValidator: MyColors.gray),
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: 150,
                              child: TextFieldCustom(
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
                                      selectedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
                                      state.controllerDateFinish.text = selectedDate;
                                    }
                                  },
                                  controller: state.controllerDateFinish,
                                  readOnly: true,
                                  text: "Data Final",
                                  hint: "",
                                  inputType: TextInputType.number,
                                  getColorValidator: MyColors.gray),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonCustom(title: "Filtrar resultados", onPressed: () async {
                          await state.getData();
                          setState(() {

                          });
                        }),
                        Visibility(
                          visible: state.trainings.isNotEmpty,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.trainings.length,
                            itemBuilder: (context, index) {
                              return CardTreino(trainingModel: state.trainings[index]);
                            },),
                        ),
                        Visibility(
                            visible: state.trainings.isEmpty,
                            child: const Center(
                          child: Text("Nenhum resultado encontrado"),
                        ))
                      ],
                    );
                  }
              }
            }),
      ),
    );
  }
}

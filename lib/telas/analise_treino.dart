import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_faculdade/listas/categorias_lista.dart';
import 'package:trabalho_faculdade/listas/provas_lista.dart';
import 'package:trabalho_faculdade/controllers/analise_treino_controller.dart';
import 'package:trabalho_faculdade/telas/selecionar_usuario.dart';
import 'package:trabalho_faculdade/util/colors.dart';
import 'package:trabalho_faculdade/widgets/button_custom.dart';
import 'package:trabalho_faculdade/widgets/bar_chart_custom.dart';
import 'package:trabalho_faculdade/widgets/text_field_custom.dart';

class AnaliseTreino extends StatefulWidget {
  const AnaliseTreino({Key? key}) : super(key: key);

  @override
  State<AnaliseTreino> createState() => _AnaliseTreinoState();
}

class _AnaliseTreinoState extends State<AnaliseTreino> {
  AnaliseTreinoController controller = AnaliseTreinoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Análise dos Treinos"),
        centerTitle: true,
      ),
      body: controller.isLoading ? const Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 30,),
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
                          selectedDate = DateFormat('dd/MM/yyyy')
                              .format(selectedDate);
                          controller.controllerDateInit.text = selectedDate;
                        }
                      },
                      controller: controller.controllerDateInit,
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
                          selectedDate = DateFormat('dd/MM/yyyy')
                              .format(selectedDate);
                          controller.controllerDateFinish.text = selectedDate;
                        }
                      },
                      controller: controller.controllerDateFinish,
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
            TextFieldCustom(
                controller: controller.controllerAthlete,
                onTap: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SelecionarUsuario(tipo: 2)));
                  if (result != null) {
                    controller.setAthlete(result);
                  }
                },
                readOnly: true,
                text: "Atleta (opcional)",
                hint: "Informe o atleta",
                inputType: TextInputType.text,
                getColorValidator: MyColors.gray),
            const SizedBox(height: 20,),
            Text("Estilo", style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400),),
            DropdownButton<String>(
              value: controller.selectedStyle,
              onChanged: (newValue) {
                controller.selectedStyle = newValue ?? "";
                setState(() {});
              },
              items: estilosLista
                  .map<DropdownMenuItem<String>>((String style) {
                return DropdownMenuItem<String>(
                  value: style,
                  child: Text(style),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            Text("Provas", style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400),),
            DropdownButton<String>(
              value: controller.selectedCategory,
              onChanged: (newValue) {
                controller.selectedCategory = newValue ?? "";
                setState(() {});
              },
              items: provasLista
                  .map<DropdownMenuItem<String>>((String event) {
                return DropdownMenuItem<String>(
                  value: event,
                  child: Text(event),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            Text("Sexo", style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400),),
            DropdownButton<String>(
              value: controller.selectedSex,
              onChanged: (newValue) {
                controller.selectedSex = newValue ?? "";
                setState(() {});
              },
              items: ['Todos', 'Masculino', 'Feminino']
                  .map<DropdownMenuItem<String>>((String sex) {
                return DropdownMenuItem<String>(
                  value: sex,
                  child: Text(sex),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            ButtonCustom(title: "Gerar dados", onPressed: () async {
              setState(() {
                controller.isLoading = true;
              });
              await controller.getData();
              setState(() {
                controller.isLoading = false;
              });
            }),
            const SizedBox(height: 40,),
            Visibility(
              visible: controller.trainings.isNotEmpty,
              child: BarChartCustom(
                title: "Número de treinos por atleta",
                sections: controller.trainingByUser,
              ),
            ),
            Visibility(
              visible: controller.trainings.isEmpty,
              child: const Center(
                child: Text("Nenhum dado encontrado"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

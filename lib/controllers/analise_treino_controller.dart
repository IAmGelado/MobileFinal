import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_faculdade/controllers/selecionar_usuario_controller.dart';
import 'package:trabalho_faculdade/entidades/atleta.dart';
import 'package:trabalho_faculdade/entidades/treino.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';

class AnaliseTreinoController {

  void setAthlete(Usuario user) {
    controllerAthlete.text = user.nome;
    idUser = user.idUsuario;
  }

  Future<void> getData() async {
    if (controllerDateInit.text.isNotEmpty && controllerDateFinish.text.isNotEmpty) {

      trainings.clear();

      var res = await FirebaseFirestore.instance.collection('treinos').get();
      var docs = res.docs;

      for (var doc in docs) {
        var obj =  Treino.fromSnapshot(doc);
        trainings.add(obj);
      }
      List<Treino> listByData = [];
      List<String> splitDateTimeInit = controllerDateInit.text.split('/');
      List<String> splitDateTimeFinish = controllerDateFinish.text.split('/');

      DateTime dtInit = DateTime(int.parse(splitDateTimeInit[2]), int.parse(splitDateTimeInit[1]), int.parse(splitDateTimeInit[0]));
      DateTime dtFinish = DateTime(int.parse(splitDateTimeFinish[2]), int.parse(splitDateTimeFinish[1]), int.parse(splitDateTimeFinish[0]));


      for (var training in trainings) {
        List<String> splitDateTimeTraining = training.data!.split('/');
        DateTime dateTraining = DateTime(int.parse(splitDateTimeTraining[2]), int.parse(splitDateTimeTraining[1]), int.parse(splitDateTimeTraining[0]));

        if (dateTraining.difference(dtInit).inDays >= 0 && dateTraining.difference(dtFinish).inDays <= 0) {
          listByData.add(training);
        }
      }

      trainings.clear();
      trainings.addAll(listByData);

      if (idUser.isNotEmpty) {
        List<Treino> listByUser = [];
        for (var training in trainings) {
          if (training.atleta.idUsuario == idUser) {
            listByUser.add(training);
          }
        }

        trainings.clear();
        trainings.addAll(listByUser);
      }

      if (selectedStyle != 'Todos') {
        List<Treino> traningsByStyle = trainings.where((e) => e.estilo == selectedStyle).toList();
        trainings.clear();
        trainings.addAll(traningsByStyle);
      }

      if (selectedCategory != 'Todos') {
        List<Treino> traningsByCategory = trainings.where((e) => e.prova == selectedCategory).toList();
        trainings.clear();
        trainings.addAll(traningsByCategory);
      }

      if (selectedSex != 'Todos') {
        SelecionarUsuarioController selectedUserController = SelecionarUsuarioController();
        List<Atleta> athletes = await selectedUserController.getAthletesBySex(selectedSex);
        List<Treino> trainingsByUser = [];
        List<Treino> trainingsByUserSex = [];

        for (var athlete in athletes) {
          trainingsByUser = trainings.where((e) => e.atleta.idUsuario == athlete.usuario.idUsuario).toList();
          trainingsByUserSex.addAll(trainingsByUser);
        }

        trainings.clear();
        trainings.addAll(trainingsByUserSex);
      }
    }

    await setTrainingByUser();
  }

  Future<void> setTrainingByUser() async {
    trainingByUser.clear();

    if (idUser == "") {
      SelecionarUsuarioController selectedUserController = SelecionarUsuarioController();
      List<Usuario> athletes = await selectedUserController.getAllAthletes();

      for (var a in athletes) {
        trainingByUser.add(ChartSection(title: a.nome, value: trainings.where((e) => e.atleta.idUsuario == a.idUsuario).length.toDouble()));
      }
    } else {
      trainingByUser.add(ChartSection(title: controllerAthlete.text, value: trainings.length.toDouble()));
    }

  }

  final TextEditingController controllerDateInit = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  final TextEditingController controllerDateFinish = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  final TextEditingController controllerAthlete = TextEditingController();
  String idUser = "";
  bool isLoading = false;
  String selectedStyle = 'Todos';
  String selectedCategory = 'Todos';
  String selectedSex = 'Todos';
  List<Treino> trainings = [];
  List<ChartSection> trainingByUser = [];
}

class ChartSection {
  String title;
  double value;

  ChartSection({required this.title, required this.value});
}
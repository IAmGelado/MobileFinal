class Util {

  static bool existStringInList(List<String> list, String value) {
    return list.indexWhere((s) => s == value) >= 0;
  }

  static bool validateEmail(String email) {
    RegExp regex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(email);
  }

  bool validateCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    if (cpf.length != 11) {
      return false;
    }

    if (cpf == '00000000000' ||
        cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999') {
      return false;
    }

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }

    int remainder = sum % 11;

    if (remainder < 2 && int.parse(cpf[9]) != 0 || remainder >= 2 && int.parse(cpf[9]) != 11 - remainder) {
      return false;
    }

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }

    remainder = sum % 11;

    if (remainder < 2 && int.parse(cpf[10]) != 0 || remainder >= 2 && int.parse(cpf[10]) != 11 - remainder) {
      return false;
    }

    return true;
  }

  bool isInteger(String input) {
    if (input == null || input.isEmpty) {
      return false;
    }
    try {
      int.parse(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool isDecimal(String input) {
    if (input == null || input.isEmpty) {
      return false;
    }
    try {
      double.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }
}
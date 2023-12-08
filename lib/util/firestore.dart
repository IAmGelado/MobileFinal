import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFile(File file, String nameFolder) async {
  var uploadTask = await FirebaseStorage.instance.ref().child(DateTime.now().toString() + nameFolder).putFile(file);
  return await (uploadTask).ref.getDownloadURL();
}

Future<File?> getFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result!.files.single.path != null) {
    final File file = File(result!.files.single.path!);
    return file;
  } else {
    return null;
  }
}
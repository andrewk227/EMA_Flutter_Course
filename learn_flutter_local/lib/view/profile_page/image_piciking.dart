import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromCamera() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> pickImageFromGallery() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class MyPickedImage extends ChangeNotifier {
  MyPickedImage({this.pickImage, this.webImage});

  //variável utilizada para obter, especificamente,  imagens da câmera do table/celular
  File? pickImage;
  Uint8List? webImage = Uint8List(8);
  bool update = false;

  Future<bool> myPickedImage() async {
    ImagePicker picker = ImagePicker();

    XFile? image;

    update = false;
    if (!kIsWeb) {
      image = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
      if (image != null) {
        pickImage = File(image.path);
        update = true;
        notifyListeners();
      }
    } else if (kIsWeb) {
      debugPrint('web platform');
      image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (image != null) {
        webImage = await image.readAsBytes();
        pickImage = File('a');
        update = true;

        notifyListeners();
      }
    }
    return update;
  }
}

import 'dart:io';

import 'package:dazzify/core/errors/exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class ImagePickingService {
  Future<File?> pickImage({required ImageSource imageSource});
}

@LazySingleton(as: ImagePickingService)
class ImagePickingServiceImpl implements ImagePickingService {
  @override
  Future<File?> pickImage({required ImageSource imageSource}) async {
    File? file;
    ImagePicker imagePicker = ImagePicker();

    try {
      XFile? xfile = await imagePicker.pickImage(source: imageSource);

      if (xfile != null) {
        file = File(xfile.path);
      }

      return file;
    } catch (e) {
      throw DataException('picking image failed, try again later.');
    }
  }
}

import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class DazzifyPickAndCropImage {
  const DazzifyPickAndCropImage();

  Future<XFile?> call();
}

@LazySingleton(as: DazzifyPickAndCropImage)
class DazzifyPickAndCropImageImpl extends DazzifyPickAndCropImage {
  final ImageCropper imageCropper;
  final ImagePicker imagePicker;
  final SettingsCubit settingsCubit;

  DazzifyPickAndCropImageImpl({
    required this.imageCropper,
    required this.imagePicker,
    required this.settingsCubit,
  });

  Color get primaryColor => settingsCubit.isDarkTheme
      ? ColorsSchemeManager.dark.primary
      : ColorsSchemeManager.light.primary;

  Color get onPrimary => settingsCubit.isDarkTheme
      ? ColorsSchemeManager.dark.onPrimary
      : ColorsSchemeManager.light.onPrimary;

  @override
  Future<XFile?> call() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final croppedFile = await imageCropper.cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: DazzifyApp.tr.cropImage,
            toolbarColor: primaryColor,
            toolbarWidgetColor: onPrimary,
            activeControlsWidgetColor: primaryColor,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: DazzifyApp.tr.cropImage,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        return XFile(croppedFile.path);
      } else {
        return null;
      }
    }
    return null;
  }
}

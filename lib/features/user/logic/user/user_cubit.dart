import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_image_cropper.dart';
import 'package:dazzify/features/user/data/models/user/user_model.dart';
import 'package:dazzify/features/user/data/models/user/user_profile_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:dazzify/features/user/data/requests/update_profile_info_request.dart';
import 'package:dazzify/features/user/data/requests/verify_update_phone_number_request.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'user_state.dart';

@Injectable()
class UserCubit extends Cubit<UserState> {
  final UserRepository _profileRepository;
  late String newPhoneNumber;
  final DazzifyPickAndCropImage dazzifyPickAndCropImage;

  UserCubit(
    this._profileRepository,
    this.dazzifyPickAndCropImage,
  ) : super(const UserState());

  Future<void> getUser() async {
    emit(state.copyWith(userState: UiState.loading));
    Either<Failure, UserModel> result = await _profileRepository.getUser();

    result.fold(
      (failure) {
        emit(state.copyWith(
            errorMessage: failure.message, userState: UiState.failure));
      },
      (user) {
        emit(state.copyWith(userModel: user, userState: UiState.success));
      },
    );
  }

  Future<void> deleteUser() async {
    emit(state.copyWith(deleteUserAccountState: UiState.loading));
    Either<Failure, Unit> result = await _profileRepository.deleteUser();

    result.fold(
      (failure) {
        emit(state.copyWith(
            errorMessage: failure.message,
            deleteUserAccountState: UiState.failure));
      },
      (unit) {
        emit(state.copyWith(
          deleteUserAccountState: UiState.success,
        ));
      },
    );
  }

  Future<void> updateProfileImage() async {
    XFile? image;
    if (state.photoPermissions == PermissionsState.granted) {
      image = await dazzifyPickAndCropImage();
    } else {
      _requestGalleryPermissions();
    }
    if (image != null) {
      emit(state.copyWith(updateProfileImageState: UiState.loading));
      final results = await _profileRepository.updateProfileImage(
        image: image,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: failure.message,
            updateProfileImageState: UiState.failure,
          ),
        ),
        (success) {
          emit(
            state.copyWith(
              updateProfileImageState: UiState.success,
              userModel: state.userModel.copyWith(
                picture: success.picture,
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> updateProfileName({required String fullName}) async {
    emit(state.copyWith(updateProfileState: UiState.loading));
    final result = await _profileRepository.updateProfileName(
      fullName: fullName,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          updateProfileState: UiState.failure,
        ),
      ),
      (updatedUserModel) => emit(
        state.copyWith(
          updateProfileState: UiState.success,
          userModel: updatedUserModel,
        ),
      ),
    );
  }

  Future<void> updateProfileInfo({
    required String email,
    required String gender,
    required int age,
  }) async {
    emit(state.copyWith(updateProfileState: UiState.loading));
    final result = await _profileRepository.updateProfileInfo(
      request: UpdateProfileInfoRequest(
        email: email,
        gender: gender,
        age: age,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          updateProfileState: UiState.failure,
        ),
      ),
      (success) {
        final profile = state.userModel.profile.copyWith(
          email: email,
          gender: gender,
          age: age,
        );
        final user = state.userModel.copyWith(profile: profile);
        emit(
          state.copyWith(
            updateProfileState: UiState.success,
            userModel: user,
          ),
        );
      },
    );
  }

  Future<void> updateProfileLang({required String lang}) async {
    emit(state.copyWith(updateProfileLangState: UiState.loading));
    final result = await _profileRepository.updateProfileLang(
      lang: lang,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          updateProfileLangState: UiState.failure,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
              updateProfileLangState: UiState.success,
              updatedLanguageCode: lang),
        );
      },
    );
  }

  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    emit(state.copyWith(updatePhoneNumberState: UiState.loading));
    final result = await _profileRepository.updatePhoneNumber(
      newPhoneNumber: newPhoneNumber,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          updatePhoneNumberState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (newNumber) {
        this.newPhoneNumber = newPhoneNumber;
        emit(
          state.copyWith(
            updatePhoneNumberState: UiState.success,
            updateNumber: newPhoneNumber,
          ),
        );
      },
    );
  }

  Future<void> verifyUpdatePhoneNumber({required String otp}) async {
    emit(state.copyWith(verifyOtpState: UiState.loading));
    final result = await _profileRepository.verifyUpdatePhoneNumber(
      request: VerifyUpdatePhoneNumberRequest(
        otp: otp,
        newPhoneNumber: newPhoneNumber,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          verifyOtpState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (verifyOtp) => emit(
        state.copyWith(
          userModel: state.userModel.copyWith(phoneNumber: newPhoneNumber),
          verifyOtpState: UiState.success,
        ),
      ),
    );
  }

  Future<void> updateUserLocation({
    required LocationModel locationModel,
  }) async {
    UserModel oldUserModel = state.userModel;
    UserProfileModel oldProfileModel = state.userModel.profile;

    UserModel newUserModel = oldUserModel.copyWith(
        profile: oldProfileModel.copyWith(
            location: LocationModel(
      longitude: locationModel.longitude,
      latitude: locationModel.latitude,
    )));

    emit(state.copyWith(userModel: newUserModel));
  }

  Future<void> _requestGalleryPermissions() async {
    emit(state.copyWith(photoPermissions: PermissionsState.initial));
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        await newerAndroidVersionsGalleryPermissions();
      } else {
        await oldAndroidVersionsGalleryPermissions();
      }
    } else if (Platform.isIOS) {
      await iosGalleryPermissions();
    }
  }

  Future<void> newerAndroidVersionsGalleryPermissions() async {
    final PermissionStatus galleryPermissions = await Permission.photos.status;
    debugPrint("PERMISSIONS : $galleryPermissions");
    switch (galleryPermissions) {
      case PermissionStatus.granted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.granted,
          ),
        );
        updateProfileImage();
      case PermissionStatus.denied:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.denied,
          ),
        );
        await Permission.photos.request();
        if (await Permission.photos.isGranted) {
          emit(
            state.copyWith(
              photoPermissions: PermissionsState.granted,
            ),
          );
          updateProfileImage();
        }
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
      case PermissionStatus.restricted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.permanentlyDenied,
          ),
        );
    }
  }

  Future<void> oldAndroidVersionsGalleryPermissions() async {
    final PermissionStatus storagePermissions = await Permission.storage.status;
    debugPrint("PERMISSIONS : $storagePermissions");
    switch (storagePermissions) {
      case PermissionStatus.granted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.granted,
          ),
        );
        updateProfileImage();
      case PermissionStatus.denied:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.denied,
          ),
        );
        await Permission.storage.request();
        if (await Permission.storage.isGranted) {
          emit(
            state.copyWith(
              photoPermissions: PermissionsState.granted,
            ),
          );
          updateProfileImage();
        }
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
      case PermissionStatus.restricted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.permanentlyDenied,
          ),
        );
    }
  }

  Future<void> iosGalleryPermissions() async {
    final PermissionStatus galleryPermissions =
        await Permission.photosAddOnly.status;
    debugPrint("PERMISSIONS : $galleryPermissions");
    switch (galleryPermissions) {
      case PermissionStatus.granted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.granted,
          ),
        );
        updateProfileImage();
      case PermissionStatus.denied:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.denied,
          ),
        );
        await Permission.photosAddOnly.request();
        if (await Permission.photosAddOnly.isGranted) {
          emit(
            state.copyWith(
              photoPermissions: PermissionsState.granted,
            ),
          );
          updateProfileImage();
        }
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
      case PermissionStatus.restricted:
        emit(
          state.copyWith(
            photoPermissions: PermissionsState.permanentlyDenied,
          ),
        );
    }
  }
}

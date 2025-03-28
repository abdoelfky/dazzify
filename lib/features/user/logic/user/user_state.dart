part of 'user_cubit.dart';

class UserState extends Equatable {
  final UiState userState;
  final UiState deleteUserAccountState;
  final UiState updateProfileImageState;
  final UiState updatePhoneNumberState;
  final UiState verifyOtpState;
  final UiState updateProfileLangState;
  final UiState updateProfileState;
  final String errorMessage;
  final UserModel userModel;
  final String updateNumber;
  final PermissionsState photoPermissions;
  final String updatedLanguageCode;

  const UserState({
    this.updateProfileImageState = UiState.initial,
    this.updatePhoneNumberState = UiState.initial,
    this.verifyOtpState = UiState.initial,
    this.updateProfileLangState = UiState.initial,
    this.updateProfileState = UiState.initial,
    this.userState = UiState.initial,
    this.deleteUserAccountState = UiState.initial,
    this.errorMessage = '',
    this.updateNumber = '',
    this.userModel = const UserModel(
      id: "",
      fullName: "",
      username: "",
      phoneNumber: "",
      points: 0,
      languagePreference: '',
      deletedAt: '',
      profile: UserProfileModel(
        gender: '',
        email: '',
        birthDay: '',
        wallet: 0,
        location: LocationModel(
          longitude: 0,
          latitude: 0,
        ),
        // age: 0,
      ),
    ),
    this.photoPermissions = PermissionsState.initial,
    this.updatedLanguageCode = '',
  });

  UserState copyWith({
    UiState? userState,
    UiState? deleteUserAccountState,
    UiState? updateProfileImageState,
    UiState? updatePhoneNumberState,
    UiState? verifyOtpState,
    UiState? updateProfileLangState,
    UiState? updateProfileState,
    String? errorMessage,
    UserModel? userModel,
    String? updateNumber,
    PermissionsState? photoPermissions,
    String? updatedLanguageCode,
  }) {
    return UserState(
      userState: userState ?? this.userState,
      deleteUserAccountState:
          deleteUserAccountState ?? this.deleteUserAccountState,
      updateProfileImageState:
          updateProfileImageState ?? this.updateProfileImageState,
      updatePhoneNumberState:
          updatePhoneNumberState ?? this.updatePhoneNumberState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      updateProfileLangState:
          updateProfileLangState ?? this.updateProfileLangState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      updateNumber: updateNumber ?? this.updateNumber,
      photoPermissions: photoPermissions ?? this.photoPermissions,
      updatedLanguageCode: updatedLanguageCode ?? this.updatedLanguageCode,
    );
  }

  @override
  List<Object?> get props => [
        updateProfileImageState,
        updatePhoneNumberState,
        verifyOtpState,
        updateProfileLangState,
        updateProfileState,
        userState,
        deleteUserAccountState,
        userModel,
        updateNumber,
        errorMessage,
        photoPermissions,
        updatedLanguageCode,
      ];
}

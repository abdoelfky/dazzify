import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/auth/data/models/auth_model.dart';
import 'package:dazzify/features/auth/data/models/app_config.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:dazzify/features/auth/data/requests/add_user_info_request.dart';
import 'package:dazzify/features/auth/data/requests/send_otp_request.dart';
import 'package:dazzify/features/auth/data/requests/validate_otp_request.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, AuthModel>> sendOtp(SendOtpRequest request);

  Future<Either<Failure, String>> validateNonExistUserOtpCode({
    required ValidateOtpRequest request,
  });

  Future<Either<Failure, TokensModel>> validateExistUserOtpCode({
    required ValidateOtpRequest request,
  });

  Future<Either<Failure, GuestModel>> guestMode({bool isClicked = false});

  Future<Either<Failure, TokensModel>> addUserInformation({
    required AddUserInfoRequest request,
    required String registerToken,
  });

  Future<Either<Failure, String>> getUserAccessToken();

  bool isUserAuthenticated();

  Future<void> deleteUserTokens();

  Future<Either<Failure, List<String>>> getAppTerms({
    required String lang,
  });
}

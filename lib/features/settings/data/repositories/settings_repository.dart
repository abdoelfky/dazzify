import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/network_exceptions.dart';
import 'package:dazzify/features/settings/data/models/privacy_policy_model.dart';

abstract class SettingsRepository {
  Future<Either<NetworkExceptions, PrivacyPoliciesResponseModel>>
      getPrivacyPolicies();
}

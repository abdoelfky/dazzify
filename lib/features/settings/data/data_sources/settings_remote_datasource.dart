import 'package:dazzify/features/settings/data/models/privacy_policy_model.dart';

abstract class SettingsRemoteDatasource {
  Future<PrivacyPoliciesResponseModel> getPrivacyPolicies();
}

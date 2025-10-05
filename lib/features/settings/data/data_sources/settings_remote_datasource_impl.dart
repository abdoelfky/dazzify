import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/features/settings/data/data_sources/settings_remote_datasource.dart';
import 'package:dazzify/features/settings/data/models/privacy_policy_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRemoteDatasource)
class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final ApiConsumer apiConsumer;

  SettingsRemoteDatasourceImpl({required this.apiConsumer});

  @override
  Future<PrivacyPoliciesResponseModel> getPrivacyPolicies() async {
    final response = await apiConsumer.get(ApiConstants.privacyPolicies);
    return PrivacyPoliciesResponseModel.fromJson(response);
  }
}

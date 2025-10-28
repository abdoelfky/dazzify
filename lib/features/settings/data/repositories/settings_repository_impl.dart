import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/network_exceptions.dart';
import 'package:dazzify/features/settings/data/data_sources/settings_remote_datasource.dart';
import 'package:dazzify/features/settings/data/models/privacy_policy_model.dart';
import 'package:dazzify/features/settings/data/repositories/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDatasource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkExceptions, PrivacyPoliciesResponseModel>>
      getPrivacyPolicies() async {
    try {
      final response = await remoteDataSource.getPrivacyPolicies();
      return Right(response);
    } catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}

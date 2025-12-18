import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:injectable/injectable.dart';

/// Simple wrapper around `/api/v1/log/event`.
///
/// Backend validation rules:
/// - Some events are "simple" and require only the `event` field.
/// - Other events require extra fields like `serviceId`, `brandId`, `bookingId`, `time`, `searchText`, etc.
/// - The full mapping between event names and required fields is documented
///   in the backend file you were sent.
///
/// This service **never throws** – failures are silently ignored so logging
/// can’t break the app flow.
@LazySingleton()
class AppEventsLogger {
  final ApiConsumer _apiConsumer;

  AppEventsLogger(this._apiConsumer);

  /// Generic logger.
  ///
  /// You are responsible for passing the correct combination of parameters
  /// according to the backend contract (see the shared TypeScript/Joi file).
  Future<void> logEvent({
    required String event,
    String? serviceId,
    String? brandId,
    String? branchId,
    String? bookingId,
    String? transactionId,
    String? mainCategoryId,
    String? mediaId,
    String? bannerId,
    String? categoryId,
    String? paymentMethodId,
    int? time, // seconds
    String? searchText,
    String? filterStatus,
  }) async {
    final body = <String, dynamic>{
      'event': event,
    };

    if (serviceId != null) body['serviceId'] = serviceId;
    if (brandId != null) body['brandId'] = brandId;
    if (branchId != null) body['branchId'] = branchId;
    if (bookingId != null) body['bookingId'] = bookingId;
    if (transactionId != null) body['transactionId'] = transactionId;
    if (mainCategoryId != null) body['mainCategoryId'] = mainCategoryId;
    if (mediaId != null) body['mediaId'] = mediaId;
    if (bannerId != null) body['bannerId'] = bannerId;
    if (categoryId != null) body['categoryId'] = categoryId;
    if (paymentMethodId != null) body['paymentMethodId'] = paymentMethodId;
    if (time != null) body['time'] = time;
    if (searchText != null && searchText.isNotEmpty) {
      body['searchText'] = searchText;
    }
    if (filterStatus != null && filterStatus.isNotEmpty) {
      body['filterStatus'] = filterStatus;
    }

    try {
      await _apiConsumer.post<void>(
        ApiConstants.logEvent,
        responseReturnType: ResponseReturnType.unit,
        body: body,
      );
    } catch (_) {
      // Swallow all errors – logging must never crash or block the user.
    }
  }

  // --- Convenience helpers for common events -------------------------------

  Future<void> logOpenApp() => logEvent(event: 'open-app');

  Future<void> logCloseApp() => logEvent(event: 'close-app');

  Future<void> logHomeClickService(String serviceId) => logEvent(
        event: 'home-click-service',
        serviceId: serviceId,
      );

  Future<void> logHomeClickBrand(String brandId) => logEvent(
        event: 'home-click-brand',
        brandId: brandId,
      );

  Future<void> logReelsWatchTime({
    required String mediaId,
    required int timeInSeconds,
  }) =>
      logEvent(
        event: AppEvents.reelsTimeWatching,
        mediaId: mediaId,
        time: timeInSeconds,
      );

  Future<void> logSearchText(String text) => logEvent(
        event: 'search-search',
        searchText: text,
      );
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static const String fontFamily = 'Cairo';
  static const String cacheFolder = 'dazzify';
  static const int imagesCacheDuration = 7;
  static const String appSettingsDatabase = 'AppSettingsDatabase';
  static const String appThemeKey = 'AppThemeKey';
  static const String localeKey = 'LocaleKey';
  static const String userTokensKey = 'UserTokensKey';
  static const String arCode = 'ar';
  static const String enCode = 'en';
  static const int phoneNumberLength = 11;
  static const int otpLength = 6;
  static const String vendorPhotosTab = "photosTab";
  static const String vendorReelsTab = "reelsTab";
  static const String vendorReviewsTab = "e-wallet";
  static const String eWalletTab = "visa";
  static const String visaCardTab = "installment";
  static const String installmentTab = "reviewsTab";
  static const String egyptFlag = "🇪🇬";
  static const String usFlag = "🇺🇸";
  static const String userLocationMarkerId = 'user-location';
  static const String male = "male";
  static const String female = "female";
  static const String generalNotificationsTopic = "GENERAL";
  static const String returnDataById = "id";
  static const String serviceId = "serviceId";
  static const String lang = "lang";
  static const String data = "data";
  static const String page = "page";
  static const String limit = "limit";
  static const String status = "status";
  static const String sort = "sort";
  static const String paymentMethod = "paymentMethod";
  static const String type = "type";
  static const String mix = "mix";
  static const String keyword = "keyword";
  static const String mainCategory = "mainCategory";
  static const String pointsAsc = "points";
  static const String pointsDesc = "-points";
  static const String ratingAsc = "rating";
  static const String ratingDesc = "-rating";
  static const String totalBookingsCountDesc = "-totalBookingsCount";
  static const String bookingCountDesc = "-bookingCount";
  static const String createdAtAsc = "createdAt";
  static const String createdAtDesc = "-createdAt";
  static const String messageType = "messageType";
  static const String content = "content";
  static const String image = "image";
  static const String today = "Today";
  static const String yesterday = "Yesterday";
  static const String location = "location";
  static const String longitude = "longitude";
  static const String latitude = "latitude";
  static const double cairoLatitude = 30.044921;
  static const double cairoLongitude = 31.236190;
  static const String branchId = "branchId";
  static const String brandId = "brandId";
  static const String startTime = "startTime";
  static const String isHasCoupon = "isHasCoupon";
  static const String bookingLocation = "bookingLocation";
  static const String zeroTime = "00:00";
  static const String twoDots = ":";
  static const String calenderDayFormat = "EEE";
  static const String month = "month";
  static const String year = "year";
  static const String gov = "gov";
  static const String purchaseAmount = "purchaseAmount";
  static const String code = "code";
  static const String lat = "lat";
  static const String lng = "lng";
  static const String couponId = "couponId";
  static const String isInBranch = "isInBranch";
  static const String cairo = "Cairo";
  static const String alexandria = "Alexandria";
  static const String giza = "Giza";
  static const String portSaid = "PortSaid";
  static const String suez = "Suez";
  static const String damietta = "Damietta";
  static const String dakahlia = "Dakahlia";
  static const String sharqia = "Sharqia";
  static const String qalyubia = "Qalyubia";
  static const String kafrElSheikh = "KafrElSheikh";
  static const String gharbia = "Gharbia";
  static const String monufia = "Monufia";
  static const String beheira = "Beheira";
  static const String ismailia = "Ismailia";
  static const String beniSuef = "BeniSuef";
  static const String fayoum = "Fayoum";
  static const String minya = "Minya";
  static const String asyut = "Asyut";
  static const String sohag = "Sohag";
  static const String qena = "Qena";
  static const String luxor = "Luxor";
  static const String aswan = "Aswan";
  static const String redSea = "RedSea";
  static const String newValley = "NewValley";
  static const String matruh = "Matruh";
  static const String northSinai = "NorthSinai";
  static const String southSinai = "SouthSinai";
  static double bottomSheetHeight = 495.h;
  static const String paymentChannel = "CloseWebView";

  static const String bannedUserTokenMessage = "Banned UserToken";
  static const String invalidUserAccessTokenMessage = "Invalid AccessToken";
  static const String invalidUserRefreshTokenMessage = "Invalid RefreshToken";

  static shareService(String serviceId) {
    return "https://share.dazzifyapp.com/service/$serviceId";
  }

  static String generateLocationHash(double latitude, double longitude) {
    const String flavor = String.fromEnvironment('env', defaultValue: 'dev');
    final payload = '$latitude|$longitude';
    late Uint8List key;
    if (flavor == 'prod') {
      key = utf8.encode(dotenv.env['PRODUCTION_ENCRYPTION_KEY']!);
    } else {
      key = utf8.encode(dotenv.env['DEVELOPMENT_ENCRYPTION_KEY']!);
    }
    final bytes = utf8.encode(payload);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  static shareBrand(String username) {
    return "https://share.dazzifyapp.com/brand/$username";
  }
}

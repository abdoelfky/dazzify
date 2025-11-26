/// Example usage of TikTok Download Event Tracking
/// أمثلة على استخدام تتبع أحداث التحميل في TikTok

import 'package:dazzify/core/services/tiktok_sdk_service.dart';

/// مثال 1: تتبع التحميل التلقائي
/// Example 1: Automatic Download Tracking
/// 
/// هذا يحدث تلقائياً في main.dart عند بدء التطبيق
/// This happens automatically in main.dart when the app starts
void exampleAutoDownloadTracking() async {
  // في main.dart - يتم استدعاؤه تلقائياً
  // In main.dart - called automatically
  await TikTokSdkService.instance.initialize();
  // ☝️ هذا يقوم بتتبع Download و AppInstall تلقائياً
  // ☝️ This automatically tracks Download and AppInstall
}

/// مثال 2: تتبع التحميل اليدوي
/// Example 2: Manual Download Tracking
/// 
/// استخدم هذا إذا أردت تتبع التحميل في وقت محدد
/// Use this if you want to track download at a specific time
void exampleManualDownloadTracking() async {
  await TikTokSdkService.instance.logDownload();
  print('✅ تم تتبع حدث Download في TikTok');
}

/// مثال 3: تتبع التحميل مع معلومات إضافية
/// Example 3: Download Tracking with Additional Details
/// 
/// أضف معلومات إضافية لفهم مصدر التحميل بشكل أفضل
/// Add extra information to better understand the download source
void exampleDownloadTrackingWithDetails() async {
  await TikTokSdkService.instance.logDownloadWithDetails(
    contentId: 'dazzify_app_v2.0.6',
    contentName: 'Dazzify Beauty App',
    source: 'tiktok_ad_campaign_beauty_2025',
  );
  print('✅ تم تتبع حدث Download مع تفاصيل في TikTok');
}

/// مثال 4: تتبع سلسلة الأحداث المهمة
/// Example 4: Track Important Event Chain
/// 
/// تتبع رحلة المستخدم الكاملة من التحميل إلى الشراء
/// Track the complete user journey from download to purchase
class UserJourneyTracking {
  
  /// الخطوة 1: عند تحميل/فتح التطبيق لأول مرة
  /// Step 1: On first app download/open
  static Future<void> trackAppDownload() async {
    await TikTokSdkService.instance.logDownload();
    print('📱 تم تتبع: تحميل التطبيق');
  }
  
  /// الخطوة 2: عند تسجيل حساب جديد
  /// Step 2: On new account registration
  static Future<void> trackRegistration() async {
    await TikTokSdkService.instance.logRegistration(method: 'phone');
    print('👤 تم تتبع: تسجيل مستخدم جديد');
  }
  
  /// الخطوة 3: عند عرض خدمة
  /// Step 3: On viewing a service
  static Future<void> trackServiceView(String serviceId, String serviceName) async {
    await TikTokSdkService.instance.logViewContent(
      contentId: serviceId,
      contentName: serviceName,
      contentCategory: 'Beauty Services',
    );
    print('👁️ تم تتبع: عرض خدمة $serviceName');
  }
  
  /// الخطوة 4: عند حجز/شراء خدمة
  /// Step 4: On booking/purchasing a service
  static Future<void> trackPurchase(double amount, String serviceId) async {
    await TikTokSdkService.instance.logPurchase(
      value: amount,
      currency: 'SAR',
      contentId: serviceId,
      contentName: 'Beauty Service',
    );
    print('💳 تم تتبع: شراء بقيمة $amount ريال');
  }
}

/// مثال 5: تتبع حسب الحملة الإعلانية
/// Example 5: Track by Ad Campaign
/// 
/// تتبع التحميلات من حملات إعلانية مختلفة
/// Track downloads from different ad campaigns
class CampaignTracking {
  
  static Future<void> trackFromBeautyAd() async {
    await TikTokSdkService.instance.logDownloadWithDetails(
      contentId: 'app_download',
      contentName: 'Dazzify App',
      source: 'tiktok_beauty_services_campaign',
    );
  }
  
  static Future<void> trackFromSalonAd() async {
    await TikTokSdkService.instance.logDownloadWithDetails(
      contentId: 'app_download',
      contentName: 'Dazzify App',
      source: 'tiktok_salon_booking_campaign',
    );
  }
  
  static Future<void> trackFromInfluencerAd(String influencerName) async {
    await TikTokSdkService.instance.logDownloadWithDetails(
      contentId: 'app_download',
      contentName: 'Dazzify App',
      source: 'tiktok_influencer_${influencerName.toLowerCase()}',
    );
  }
}

/// مثال 6: استخدام حدث مخصص
/// Example 6: Custom Event Usage
/// 
/// إنشاء أحداث مخصصة لحالات استخدام محددة
/// Create custom events for specific use cases
class CustomEventTracking {
  
  static Future<void> trackAppReinstall() async {
    await TikTokSdkService.instance.logEvent(
      eventName: 'AppReinstall',
      parameters: {
        'event_type': 'app_reinstall',
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    );
  }
  
  static Future<void> trackReferralDownload(String referralCode) async {
    await TikTokSdkService.instance.logDownloadWithDetails(
      contentId: 'app_download',
      contentName: 'Dazzify App',
      source: 'referral_$referralCode',
    );
  }
}

/// مثال كامل: تطبيق عملي
/// Complete Example: Practical Implementation
/// 
/// كيفية دمج التتبع في تطبيقك
/// How to integrate tracking in your app
class PracticalExample {
  
  /// عند بدء التطبيق
  /// On app startup
  static Future<void> onAppStartup() async {
    // التهيئة التلقائية - تتبع Download و AppInstall
    // Automatic initialization - tracks Download and AppInstall
    await TikTokSdkService.instance.initialize();
    
    print('✅ TikTok Tracking جاهز - تم تتبع Download و AppInstall');
  }
  
  /// عند تسجيل دخول/إنشاء حساب
  /// On login/registration
  static Future<void> onUserRegistration(String method) async {
    await TikTokSdkService.instance.logRegistration(method: method);
    print('✅ تم تتبع تسجيل مستخدم جديد');
  }
  
  /// عند عرض صفحة منتج/خدمة
  /// On viewing product/service page
  static Future<void> onViewServiceDetails(Map<String, dynamic> service) async {
    await TikTokSdkService.instance.logViewContent(
      contentId: service['id'].toString(),
      contentName: service['name'],
      contentCategory: service['category'],
    );
    print('✅ تم تتبع عرض خدمة: ${service['name']}');
  }
  
  /// عند إتمام عملية شراء
  /// On completing a purchase
  static Future<void> onPurchaseComplete(Map<String, dynamic> booking) async {
    await TikTokSdkService.instance.logPurchase(
      value: booking['total_amount'],
      currency: 'SAR',
      contentId: booking['service_id'].toString(),
      contentName: booking['service_name'],
    );
    print('✅ تم تتبع عملية شراء بقيمة ${booking['total_amount']} ريال');
  }
}

/// الأحداث المهمة لـ TikTok Ads
/// Important Events for TikTok Ads
/// 
/// الترتيب حسب الأهمية:
/// Ordered by importance:
/// 
/// 1. ⭐⭐⭐ Download - أهم حدث لتتبع عدد التحميلات
/// 2. ⭐⭐⭐ Purchase - ثاني أهم حدث لتتبع الإيرادات
/// 3. ⭐⭐ Registration - مهم لتتبع المستخدمين الجدد
/// 4. ⭐⭐ ViewContent - مهم لفهم سلوك المستخدمين
/// 5. ⭐ InitiateCheckout - مفيد لتحسين معدل التحويل
/// 
/// جميع الأحداث متاحة الآن وجاهزة للاستخدام! ✅
/// All events are now available and ready to use! ✅

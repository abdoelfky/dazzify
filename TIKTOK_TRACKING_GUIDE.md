# دليل تتبع أحداث TikTok Ads - TikTok Ads Tracking Guide

## معلومات الحساب - Account Information

- **TikTok API Key**: `TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF`
- **TikTok App ID**: `7565017967432450049`

## الأحداث المتتبعة - Tracked Events

### 1. Download (حدث التحميل) ⭐ **الأهم**
هذا هو أهم حدث لإعلانات TikTok لتتبع عدد تحميلات التطبيق.

**الاستخدام:**
```dart
// تتبع تحميل التطبيق بشكل تلقائي عند أول فتح
await TikTokSdkService.instance.logDownload();

// أو مع معلومات إضافية
await TikTokSdkService.instance.logDownloadWithDetails(
  contentId: 'app_v2.0.6',
  contentName: 'Dazzify App',
  source: 'tiktok_ad_campaign',
);
```

### 2. AppInstall (حدث التثبيت)
يتتبع فتح التطبيق لأول مرة بعد التثبيت.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logAppInstall();
```

### 3. Registration (حدث التسجيل)
يتتبع تسجيل المستخدمين الجدد.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logRegistration(method: 'phone');
```

### 4. Purchase (حدث الشراء)
يتتبع المشتريات داخل التطبيق.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logPurchase(
  value: 100.0,
  currency: 'SAR',
  contentId: 'service_123',
  contentName: 'Beauty Service',
);
```

### 5. ViewContent (حدث عرض المحتوى)
يتتبع عرض المستخدمين للخدمات أو المنتجات.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logViewContent(
  contentId: 'service_123',
  contentName: 'Haircut Service',
  contentCategory: 'Beauty',
);
```

### 6. AddToCart (حدث الإضافة للسلة)
يتتبع إضافة العناصر للسلة.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logAddToCart(
  contentId: 'service_123',
  contentName: 'Haircut Service',
  value: 50.0,
  currency: 'SAR',
);
```

### 7. InitiateCheckout (حدث بدء الدفع)
يتتبع بدء عملية الدفع.

**الاستخدام:**
```dart
await TikTokSdkService.instance.logCheckout(
  value: 100.0,
  currency: 'SAR',
  contentIds: ['service_123', 'service_456'],
);
```

## كيفية العمل - How It Works

### iOS
- يستخدم `TikTokBusinessSDK` الأصلي
- التتبع يعمل بشكل مباشر مع TikTok
- الأحداث ترسل في الوقت الفعلي

### Android
- حاليًا يستخدم تسجيل محلي (Local Logging)
- TikTok SDK غير متوفر في Maven العامة
- **يُنصح**: تنفيذ TikTok Events API من جهة الخادم للإنتاج

## التكامل التلقائي - Automatic Integration

عند تشغيل التطبيق، يتم تلقائيًا:
1. ✅ تهيئة TikTok SDK
2. ✅ تتبع حدث Download
3. ✅ تتبع حدث AppInstall

```dart
// في main.dart
await TikTokSdkService.instance.initialize();
// هذا يقوم تلقائيًا بتتبع Download و AppInstall
```

## أين يتم التتبع حاليًا - Current Tracking Locations

| الحدث | الموقع في الكود |
|------|----------------|
| Download | `main.dart` - عند بدء التطبيق |
| AppInstall | `main.dart` - عند بدء التطبيق |
| Registration | `auth_cubit.dart` - عند التسجيل بالهاتف |
| Purchase | `service_invoice_cubit.dart` - عند إتمام الحجز |
| ViewContent | `service_details_bloc.dart` - عند عرض تفاصيل الخدمة |

## ملاحظات مهمة - Important Notes

### ✅ مميزات التنفيذ الحالي
- تتبع Download تلقائي عند أول فتح للتطبيق
- دعم كامل على iOS مع TikTokBusinessSDK
- تتبع جميع الأحداث المهمة (Registration, Purchase, ViewContent)
- معالجة آمنة للأخطاء بدون تعطيل التطبيق

### ⚠️ للتحسين المستقبلي
- على Android: تنفيذ TikTok Events API من جهة الخادم
- إضافة تتبع لأحداث إضافية حسب الحاجة
- مزامنة الأحداث عندما يكون الإنترنت غير متاح

## API Reference

### TikTokSdkService Methods

```dart
class TikTokSdkService {
  // تهيئة SDK
  Future<void> initialize()
  
  // تتبع التحميل (الأهم)
  Future<void> logDownload()
  Future<void> logDownloadWithDetails({
    String? contentId,
    String? contentName,
    String? source,
  })
  
  // تتبع التثبيت
  Future<void> logAppInstall()
  
  // تتبع بدء التطبيق
  Future<void> logAppLaunch()
  
  // تتبع التسجيل
  Future<void> logRegistration({required String method})
  
  // تتبع الشراء
  Future<void> logPurchase({
    required double value,
    required String currency,
    String? contentId,
    String? contentName,
  })
  
  // تتبع عرض المحتوى
  Future<void> logViewContent({
    required String contentId,
    String? contentName,
    String? contentCategory,
  })
  
  // تتبع الإضافة للسلة
  Future<void> logAddToCart({
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  })
  
  // تتبع بدء الدفع
  Future<void> logCheckout({
    double? value,
    String? currency,
    List<String>? contentIds,
  })
  
  // تتبع حدث مخصص
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  })
}
```

## الدعم - Support

للمزيد من المعلومات حول TikTok Events API:
- [TikTok Events API Documentation](https://business-api.tiktok.com/portal/docs?id=1741601162187777)
- [TikTok Business SDK for iOS](https://developers.tiktok.com/doc/business-sdk-ios)

---

**تم التنفيذ بنجاح ✅**
- حدث Download متاح ويعمل
- جميع الأحداث المهمة متتبعة
- التكامل تلقائي عند بدء التطبيق

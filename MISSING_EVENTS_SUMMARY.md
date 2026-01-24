# ملخص الأحداث المفقودة - Missing Events Summary

## 📋 النتيجة الإجمالية

- **إجمالي الأحداث المطلوبة:** 241
- **الأحداث المطبقة:** ~220 (91%)
- **الأحداث المفقودة:** 16 (7%)
- **الأحداث التي تحتاج تصحيح:** 3 (1%)

---

## ❌ الأحداث المفقودة بالكامل (16 حدث)

### 1. Calendar Page (2 أحداث)
- ❌ `calendar-agree-terms` - عند الموافقة على الشروط
- ❌ `calendar-cancel-terms` - عند إلغاء الموافقة على الشروط

**الموقع:** `lib/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart`

---

### 2. Confirmation Booking Page (13 حدث)
جميع الأحداث التالية مفقودة من شاشة تأكيد الحجز:

- ❌ `confirmtionbooking-click-back` - زر الرجوع
- ❌ `confirmtionbooking-click-inbranch` - اختيار "في الفرع"
- ❌ `confirmtionbooking-click-branchlocation` - الضغط على موقع الفرع
- ❌ `confirmtionbooking-click-outbranch` - اختيار "خارج الفرع"
- ❌ `confirmtionbooking-click-selectgovernorate` - اختيار المحافظة
- ❌ `confirmtionbooking-click-selectlocation` - اختيار الموقع
- ❌ `confirmtionbooking-click-confirmelocation` - تأكيد الموقع
- ❌ `confirmtionbooking-add-notes` - إضافة ملاحظات
- ❌ `confirmtionbooking-remove-notes` - حذف الملاحظات
- ❌ `confirmtionbooking-add-coupone` - إضافة كوبون
- ❌ `confirmtionbooking-remove-coupone` - حذف الكوبون
- ❌ `confirmtionbooking-submit-booking` - إرسال الحجز
- ❌ `confirmtionbooking-click-12h-gotohome` - العودة للرئيسية (يوجد لكن يستخدم اسم خاطئ)

**المواقع:**
- `lib/features/booking/presentation/screens/service_invoice_screen.dart` - معظم التفاعلات هنا
- `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart` - شاشة التأكيد

---

### 3. Reels Page (1 حدث)
- ❌ `reels-time-start-end-watching` (time in seconds)

**ملاحظة:** Helper method موجود في `AppEventsLogger.logReelsWatchTime()` لكن غير مستخدم

**الموقع:** `lib/features/reels/presentation/screens/reels_screen.dart`

---

## ⚠️ الأحداث التي تحتاج تصحيح (3 أحداث)

### 1. Calendar Date Selection
- **المشكلة:** يستخدم `calendar-click-date` بدلاً من `calendar-select-date`
- **الموقع:** `lib/features/booking/presentation/widgets/date_selection_widget/date_selection_widget.dart:54`
- **الحل:** تغيير `AppEvents.calendarClickDate` إلى `AppEvents.calendarSelectDate`

### 2. Calendar Time Selection
- **المشكلة:** يستخدم `calendar-click-time` بدلاً من `calendar-select-time`
- **المواقع:**
  - `lib/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/analog_clock.dart:27`
  - `lib/features/booking/presentation/widgets/time_selection_widget/components/digital_clock/digital_clock.dart:68,91`
- **الحل:** تغيير `AppEvents.calendarClickTime` إلى `AppEvents.calendarSelectTime`

### 3. Confirmation Booking Back Home
- **المشكلة:** يستخدم `confirmation-click-back-home` بدلاً من `confirmtionbooking-click-12h-gotohome`
- **الموقع:** `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart:64`
- **الحل:** تغيير `AppEvents.confirmationClickBackHome` إلى `AppEvents.confirmationBookingClick12hGoToHome`

---

## 🔧 الإجراءات المطلوبة

### 1. إضافة الثوابت المفقودة في `app_events.dart`
```dart
// Calendar Page - إضافة
static const String calendarSelectDate = 'calendar-select-date';
static const String calendarSelectTime = 'calendar-select-time';
static const String calendarAgreeTerms = 'calendar-agree-terms';
static const String calendarCancelTerms = 'calendar-cancel-terms';
```

### 2. تصحيح استخدام الأحداث
- استبدال `calendarClickDate` بـ `calendarSelectDate`
- استبدال `calendarClickTime` بـ `calendarSelectTime`
- استبدال `confirmationClickBackHome` بـ `confirmationBookingClick12hGoToHome`

### 3. إضافة الأحداث المفقودة في الشاشات
- إضافة أحداث Calendar Terms في `brand_terms_sheet.dart`
- إضافة جميع أحداث Confirmation Booking في `service_invoice_screen.dart`
- إضافة Reels time tracking في `reels_screen.dart`

---

## 📍 الملفات التي تحتاج تعديل

1. `lib/core/constants/app_events.dart` - إضافة الثوابت المفقودة
2. `lib/features/booking/presentation/widgets/date_selection_widget/date_selection_widget.dart` - تصحيح اسم الحدث
3. `lib/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/analog_clock.dart` - تصحيح اسم الحدث
4. `lib/features/booking/presentation/widgets/time_selection_widget/components/digital_clock/digital_clock.dart` - تصحيح اسم الحدث
5. `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart` - تصحيح اسم الحدث
6. `lib/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart` - إضافة أحداث agree/cancel terms
7. `lib/features/booking/presentation/screens/service_invoice_screen.dart` - إضافة جميع أحداث confirmation booking
8. `lib/features/reels/presentation/screens/reels_screen.dart` - إضافة time tracking

---

## ✅ الأحداث المطبقة بشكل صحيح

جميع الأحداث الأخرى (~220 حدث) مطبقة بشكل صحيح في:
- Navigation Bar
- Home Page
- Search & Search Media
- Chat
- Profile
- Brand Pages
- Service Details
- Booking Status
- Payment Pages
- وغيرها...

---

## 🎯 الأولوية

### عالية (يجب إصلاحها فوراً)
1. ✅ تصحيح أسماء الأحداث (calendar-select-date/time, confirmation-click-back-home)
2. ✅ إضافة أحداث Calendar Terms
3. ✅ إضافة أحداث Confirmation Booking المفقودة

### متوسطة
4. ✅ إضافة Reels time watching tracking

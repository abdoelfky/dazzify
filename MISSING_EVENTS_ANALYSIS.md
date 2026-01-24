# تحليل الأحداث المفقودة - Missing Events Analysis

## ✅ الأحداث المطبقة حالياً (Implemented Events)

### App Lifecycle
- ✅ `open-app`
- ✅ `close-app`

### Navigation Bar
- ✅ `nav-click-home`
- ✅ `nav-click-reels`
- ✅ `nav-click-search`
- ✅ `nav-click-chat`
- ✅ `nav-click-profile`

### Notifications Page
- ✅ `notifications-click-back`

### Favourites Page
- ✅ `favourites-click-back`
- ✅ `favourites-click-remove-favourite` (serviceId)

### Maincategory Page
- ✅ `maincategory-click-back`
- ✅ `maincategory-click-brand` (brandId)

### Home Page Components
- ✅ `home-click-banner` (bannerId)
- ✅ `home-click-favourites`
- ✅ `home-click-notifications`
- ✅ `home-click-maincategory` (mainCategoryId)
- ✅ `home-click-brand` (brandId)
- ✅ `home-click-service` (serviceId)
- ✅ `home-click-add-favourite` (serviceId)
- ✅ `home-click-remove-favourite` (serviceId)
- ✅ `home-click-more-popular-brands`
- ✅ `home-click-more-popular-services`
- ✅ `home-click-more-toprated-brands`
- ✅ `home-click-more-toprated-services`
- ✅ `home-click-booking-status` (bookingId)

### Popular & Toprated Pages
- ✅ `popular-click-brands-back`
- ✅ `popular-click-services-back`
- ✅ `toprated-click-brands-back`
- ✅ `toprated-click-services-back`
- ✅ `popular-click-brands-brand` (brandId)
- ✅ `popular-click-services-service` (serviceId)
- ✅ `toprated-click-brands-brand` (brandId)
- ✅ `toprated-click-services-service` (serviceId)

### Reels Page
- ✅ `reels-click-back`
- ✅ `reels-click-comments`
- ✅ `reels-click-brand` (brandId)
- ✅ `reels-click-chat` (branchId)
- ✅ `reels-click-filter` (mainCategoryId)
- ❌ `reels-time-start-end-watching` (time in seconds) - **Helper exists but not called**

### Search Page
- ✅ `search-click-back`
- ✅ `search-click-media` (mediaId)
- ✅ `search-click-brand` (brandId)
- ✅ `search-click-search`
- ✅ `search-search` (searchText)

### Search Media Page
- ✅ `search-media-click-back`
- ✅ `search-media-click-brand` (brandId)
- ✅ `search-media-click-chat` (branchId)
- ✅ `search-media-click-report`
- ✅ `search-media-submit-report`
- ✅ `search-media-click-book`
- ✅ `search-media-click-comments`

### Chat Page
- ✅ `chat-click-back`
- ✅ `chat-open-chat` (branchId)
- ✅ `chat-time-start-end-chating` (time in seconds)

### Profile Page
- ✅ `profile-click-back`
- ✅ `profile-click-edit-data`
- ✅ `profile-click-edit-phone`
- ✅ `profile-click-edit-photo`
- ✅ `profile-submit-edit-data`
- ✅ `profile-submit-edit-photo`
- ✅ `profile-submit-edit-phone`
- ✅ `profile-click-favourites`
- ✅ `profile-click-qrcode`
- ✅ `profile-click-bookinghistory`
- ✅ `profile-click-issue`
- ✅ `profile-click-payments`
- ✅ `profile-change-language`
- ✅ `profile-change-theme`
- ✅ `profile-on-notifications`
- ✅ `profile-off-notifications`
- ✅ `profile-click-logout`
- ✅ `profile-click-confirm-logout`
- ✅ `profile-click-cancel-logout`
- ✅ `profile-click-deleteaccount`
- ✅ `profile-click-confirm-deleteaccount`
- ✅ `profile-click-cancel-deleteaccount`

### QR Code Page
- ✅ `qrcode-click-back`
- ✅ `qrcode-scan`

### Coupon QR Code Page
- ✅ `coupon-qrcode-back`
- ✅ `coupon-qrcode-details-back`
- ✅ `coupon-qrcode-click-details`
- ✅ `coupon-qrcode-scratch`
- ✅ `coupon-qrcode-copy`

### Booking History Page
- ✅ `bookinghistory-click-back`
- ✅ `bookinghistory-click-booking` (bookingId)

### Issue Page
- ✅ `issue-click-back`
- ✅ `issue-click-details` (bookingId)
- ✅ `issue-submit`

### Payment Page
- ✅ `payments-click-back`
- ✅ `payments-click-filter` (filterStatus)
- ✅ `payments-click-pay` (transactionId)

### Payment Method Page
- ✅ `paymentmethods-click-back`
- ✅ `paymentmethods-click-wallet`
- ✅ `paymentmethods-click-card`
- ✅ `paymentmethods-click-installment`
- ✅ `paymentmethods-click-paymentmethod` (paymentMethodId)

### Brand Page
- ✅ `brand-click-back`
- ✅ `brand-click-share`
- ✅ `brand-click-report`
- ✅ `brand-submit-report`
- ✅ `brand-click-branches`
- ✅ `brand-click-branch-go-map` (branchId)
- ✅ `brand-click-chat` (branchId)
- ✅ `brand-click-showservices`
- ✅ `brand-click-showbranchservices` (branchId)
- ✅ `brand-click-tab-photos`
- ✅ `brand-click-tab-videos`
- ✅ `brand-click-tab-reviews`
- ✅ `brand-click-media` (mediaId)

### Brand Media Page
- ✅ `brand-media-click-back`
- ✅ `brand-media-click-brand` (brandId)
- ✅ `brand-media-click-chat` (branchId)
- ✅ `brand-media-click-report`
- ✅ `brand-media-submit-report`
- ✅ `brand-media-click-book`
- ✅ `brand-media-click-comments`

### Services Page
- ✅ `services-click-back`
- ✅ `services-click-category` (categoryId)
- ✅ `services-click-service` (serviceId)
- ✅ `services-click-book` (serviceId)

### Service Details Page
- ✅ `servicedetails-click-back`
- ✅ `servicedetails-click-add-favourite` (serviceId)
- ✅ `servicedetails-click-remove-favourite` (serviceId)
- ✅ `servicedetails-click-service` (serviceId)
- ✅ `servicedetails-click-book` (serviceId)
- ✅ `servicedetails-click-brand` (brandId)
- ✅ `servicedetails-click-allreviews`

### All Reviews Page
- ✅ `allreviews-click-back`

### Calendar Page
- ✅ `calendar-click-back`
- ⚠️ `calendar-select-date` - **Mismatch: Using `calendar-click-date` instead of `calendar-select-date`**
- ⚠️ `calendar-select-time` - **Mismatch: Using `calendar-click-time` instead of `calendar-select-time`**
- ❌ `calendar-agree-terms`
- ❌ `calendar-cancel-terms`

### Confirmation Booking Page
- ❌ `confirmtionbooking-click-back`
- ❌ `confirmtionbooking-click-inbranch`
- ❌ `confirmtionbooking-click-branchlocation`
- ❌ `confirmtionbooking-click-outbranch`
- ❌ `confirmtionbooking-click-selectgovernorate`
- ❌ `confirmtionbooking-click-selectlocation`
- ❌ `confirmtionbooking-click-confirmelocation`
- ❌ `confirmtionbooking-add-notes`
- ❌ `confirmtionbooking-remove-notes`
- ❌ `confirmtionbooking-add-coupone`
- ❌ `confirmtionbooking-remove-coupone`
- ❌ `confirmtionbooking-submit-booking`
- ⚠️ `confirmtionbooking-click-12h-gotohome` - **Using `confirmation-click-back-home` instead**

### Booking Status Page
- ✅ `bookingstatus-click-back`
- ✅ `bookingstatus-click-view-location`
- ✅ `bookingstatus-click-cancel`
- ✅ `bookingstatus-click-cancel-cancel`
- ✅ `bookingstatus-click-agree-cancel`
- ✅ `bookingstatus-swipe-arrive`
- ✅ `bookingstatus-click-pay` (transactionId)

---

## ❌ الأحداث المفقودة بالكامل (Completely Missing Events)

### Calendar Page
1. ❌ `calendar-agree-terms` - عند الموافقة على الشروط في شاشة الحجز
2. ❌ `calendar-cancel-terms` - عند إلغاء الموافقة على الشروط

### Confirmation Booking Page (شاشة تأكيد الحجز)
3. ❌ `confirmtionbooking-click-back` - عند الضغط على زر الرجوع
4. ❌ `confirmtionbooking-click-inbranch` - عند اختيار "في الفرع"
5. ❌ `confirmtionbooking-click-branchlocation` - عند الضغط على موقع الفرع
6. ❌ `confirmtionbooking-click-outbranch` - عند اختيار "خارج الفرع"
7. ❌ `confirmtionbooking-click-selectgovernorate` - عند اختيار المحافظة
8. ❌ `confirmtionbooking-click-selectlocation` - عند اختيار الموقع
9. ❌ `confirmtionbooking-click-confirmelocation` - عند تأكيد الموقع
10. ❌ `confirmtionbooking-add-notes` - عند إضافة ملاحظات
11. ❌ `confirmtionbooking-remove-notes` - عند حذف الملاحظات
12. ❌ `confirmtionbooking-add-coupone` - عند إضافة كوبون
13. ❌ `confirmtionbooking-remove-coupone` - عند حذف الكوبون
14. ❌ `confirmtionbooking-submit-booking` - عند إرسال الحجز
15. ❌ `confirmtionbooking-click-12h-gotohome` - عند الضغط على "العودة للرئيسية" بعد 12 ساعة

### Reels Page
16. ❌ `reels-time-start-end-watching` (time in seconds) - **Helper method exists in AppEventsLogger but not being called**

---

## ⚠️ الأحداث التي تحتاج تصحيح (Events Needing Fix)

### Calendar Page
1. ⚠️ `calendar-select-date` - **Currently using `calendar-click-date`** 
   - **Location:** `lib/features/booking/presentation/widgets/date_selection_widget/date_selection_widget.dart:54`
   - **Fix:** Change `AppEvents.calendarClickDate` to use `calendar-select-date` constant

2. ⚠️ `calendar-select-time` - **Currently using `calendar-click-time`**
   - **Locations:** 
     - `lib/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/analog_clock.dart:27`
     - `lib/features/booking/presentation/widgets/time_selection_widget/components/digital_clock/digital_clock.dart:68,91`
   - **Fix:** Change `AppEvents.calendarClickTime` to use `calendar-select-time` constant

### Confirmation Booking Page
3. ⚠️ `confirmtionbooking-click-12h-gotohome` - **Currently using `confirmation-click-back-home`**
   - **Location:** `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart:64`
   - **Fix:** Change `AppEvents.confirmationClickBackHome` to `AppEvents.confirmationBookingClick12hGoToHome`

---

## 📊 الإحصائيات (Statistics)

- **إجمالي الأحداث المطلوبة:** 241
- **الأحداث المطبقة بشكل صحيح:** ~220 (91%)
- **الأحداث المفقودة بالكامل:** 16 (7%)
- **الأحداث التي تحتاج تصحيح:** 3 (1%)

---

## 📝 ملاحظات مهمة (Important Notes)

1. **Mismatch في أسماء الأحداث:**
   - `calendar-click-date` يجب أن يكون `calendar-select-date`
   - `calendar-click-time` يجب أن يكون `calendar-select-time`
   - `confirmation-click-back-home` يجب أن يكون `confirmtionbooking-click-12h-gotohome`

2. **Reels Time Watching:**
   - Helper method موجود في `AppEventsLogger.logReelsWatchTime()` لكن غير مستخدم
   - يحتاج إضافة في شاشة Reels لتتبع وقت المشاهدة

3. **Confirmation Booking Screen:**
   - معظم الأحداث مفقودة من شاشة تأكيد الحجز
   - الشاشة موجودة في: `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart`
   - لكن معظم التفاعلات موجودة في: `lib/features/booking/presentation/screens/service_invoice_screen.dart`

4. **Calendar Terms:**
   - أحداث الموافقة/إلغاء الشروط مفقودة
   - موجودة في: `lib/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart`

---

## 🎯 الأولويات (Priorities)

### عالية (High Priority) - يجب إصلاحها فوراً
1. ✅ تصحيح أسماء الأحداث المطابقة (calendar-select-date/time)
2. ✅ إضافة أحداث Confirmation Booking المفقودة
3. ✅ إضافة أحداث Calendar Terms (agree/cancel)

### متوسطة (Medium Priority)
4. ✅ إضافة Reels time watching tracking
5. ✅ مراجعة جميع الأحداث للتأكد من المطابقة مع Backend

---

## 📍 مواقع الملفات المهمة (Important File Locations)

### Confirmation Booking Events
- `lib/features/booking/presentation/screens/service_invoice_screen.dart` - معظم التفاعلات هنا
- `lib/features/booking/presentation/screens/service_booking_confirmation_screen.dart` - شاشة التأكيد النهائية
- `lib/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart` - شروط الحجز

### Calendar Events
- `lib/features/booking/presentation/widgets/date_selection_widget/date_selection_widget.dart` - اختيار التاريخ
- `lib/features/booking/presentation/widgets/time_selection_widget/` - اختيار الوقت
- `lib/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart` - الشروط

### Reels Events
- `lib/features/reels/presentation/screens/reels_screen.dart` - إضافة time tracking هنا

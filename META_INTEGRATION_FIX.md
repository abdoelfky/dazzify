# Meta Integration Fix for Facebook/Instagram Ad Tracking

## Problem Summary
The Meta SDK (`flutter_meta_sdk`) was declared in `pubspec.yaml` but was **never initialized or used** in the codebase. This meant that:
- No Facebook/Instagram ad events were being tracked
- No conversion tracking was happening
- Ad performance metrics were not being collected

## What Was Fixed

### 1. Created Meta Analytics Service (`lib/core/services/meta_analytics_service.dart`)
- Created a service wrapper for the Meta SDK
- Follows the same pattern as other services (FCMNotification)
- Provides methods for:
  - `init()` - Initialize Meta SDK
  - `logEvent()` - Log custom events
  - `logPurchase()` - Track purchases/bookings
  - `logAddToCart()` - Track items added to cart
  - `logViewContent()` - Track content views
  - `setUserId()` - Set user ID for tracking

### 2. Initialized Meta SDK in `main.dart`
Added Meta SDK initialization after FCM notification setup:
```dart
// Initialize Meta SDK for Facebook/Instagram ad tracking
final metaAnalytics = getIt<MetaAnalyticsService>();
await metaAnalytics.init();
```

### 3. Added Event Tracking Throughout the App

#### Booking Creation (`lib/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart`)
- Tracks `Purchase` event when booking is created
- Logs booking details including:
  - Brand ID and Branch ID
  - Number of services
  - Total amount
  - Coupon usage

#### Service Views (`lib/features/home/logic/service_details/service_details_bloc.dart`)
- Tracks `ViewContent` event when user views a service
- Logs service details including:
  - Service ID and name
  - Brand ID and name
  - Price

#### Banner/Ad Clicks (`lib/features/home/helper/banner_helper.dart`)
- Tracks `BannerClick` event when user clicks on banners
- Logs banner action type and position

#### User Login (`lib/features/user/logic/user/user_cubit.dart`)
- Sets user ID in Meta SDK when user logs in
- Tracks `UserLogin` event with user details

## Required Steps to Complete the Fix

### 1. Run Build Runner
Since we modified dependency injection (added MetaAnalyticsService to constructors), you need to regenerate the injection code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Verify Meta SDK Configuration

#### Android (`android/app/src/main/res/values/strings.xml`)
Verify your Facebook App ID and Client Token are correct:
```xml
<string name="facebook_app_id">2967524626742822</string>
<string name="facebook_client_token">49cecb36f2affc7f6ed198561f5512c2</string>
```

#### iOS (`ios/Runner/Info.plist`)
Add Facebook configuration if not present:
```xml
<key>FacebookAppID</key>
<string>2967524626742822</string>
<key>FacebookClientToken</key>
<string>49cecb36f2affc7f6ed198561f5512c2</string>
<key>FacebookDisplayName</key>
<string>Dazzify</string>
```

### 3. Test the Integration

1. **Run the app:**
   ```bash
   flutter run --flavor=dev --dart-define=env=dev
   ```

2. **Test these scenarios:**
   - View a service (should log `ViewContent` event)
   - Click on a banner (should log `BannerClick` event)
   - Create a booking (should log `Purchase` event)
   - Login (should set user ID and log `UserLogin` event)

3. **Verify in Facebook Events Manager:**
   - Go to https://business.facebook.com/events_manager
   - Select your app
   - Check "Test Events" to see real-time events
   - Verify events are being received

### 4. Additional Tracking (Optional)
You may want to add tracking for:
- Product searches
- Adding items to wishlist/favorites
- Checkout initiated
- Registration completed

## Meta SDK Events Reference

The Meta SDK tracks these standard events:
- `Purchase` - When user completes a purchase/booking
- `ViewContent` - When user views a service/product
- `AddToCart` - When user adds item to cart
- `Search` - When user searches
- `AddToWishlist` - When user adds to favorites
- `InitiateCheckout` - When user starts checkout
- `CompleteRegistration` - When user completes registration

## Troubleshooting

### Events Not Showing in Facebook
1. Check Meta SDK is initialized (check logs for "✅ Meta SDK initialized successfully")
2. Verify Facebook App ID and Client Token are correct
3. Make sure app is in Test mode in Facebook App settings
4. Check Facebook Events Manager Test Events tab

### Build Errors
If you get dependency injection errors:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Runtime Errors
Check logs for Meta SDK errors:
- "❌ Error initializing Meta SDK"
- "❌ Error logging Meta event"

## Currency Configuration
Currently set to 'EGP' (Egyptian Pound). To change:
Edit `lib/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart`:
```dart
_metaAnalytics.logPurchase(
  totalAmount,
  'USD', // Change currency code here
);
```

## Next Steps
1. Run build_runner command
2. Test on real device
3. Verify events in Facebook Events Manager
4. Enable production mode in Facebook App settings
5. Create Facebook/Instagram ad campaigns using the tracked events

## Files Modified
- ✅ `lib/core/services/meta_analytics_service.dart` (NEW)
- ✅ `lib/main.dart`
- ✅ `lib/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart`
- ✅ `lib/features/home/logic/service_details/service_details_bloc.dart`
- ✅ `lib/features/home/helper/banner_helper.dart`
- ✅ `lib/features/user/logic/user/user_cubit.dart`

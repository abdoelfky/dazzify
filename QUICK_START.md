# Quick Start - Meta Integration Fix

## ⚠️ IMPORTANT: Run This Command First

After pulling these changes, you **MUST** run the following command to regenerate dependency injection code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This is required because we added `MetaAnalyticsService` to several constructors.

## What Was Fixed?

✅ **Meta SDK was not initialized** - Now it's properly initialized in `main.dart`  
✅ **No event tracking** - Now tracking bookings, service views, banner clicks, and logins  
✅ **No user identification** - Now setting user ID when they log in  
✅ **Missing service wrapper** - Created `MetaAnalyticsService` for easy Meta SDK access  

## How to Test?

1. **Run the build_runner command above**
2. **Run the app:**
   ```bash
   flutter run --flavor=dev --dart-define=env=dev
   ```
3. **Check logs for:**
   ```
   ✅ Meta SDK initialized successfully
   📊 Logging Meta event: ViewService
   💰 Logging Meta purchase: 500.0 EGP
   ```

4. **Verify in Facebook Events Manager:**
   - Go to: https://business.facebook.com/events_manager
   - Select your app
   - Check "Test Events" tab
   - You should see events coming in real-time

## What Events Are Being Tracked?

| Event | When | Location |
|-------|------|----------|
| **Purchase** | User completes booking | `service_invoice_cubit.dart` |
| **ViewContent** | User views service details | `service_details_bloc.dart` |
| **BannerClick** | User clicks banner/ad | `banner_helper.dart` |
| **UserLogin** | User logs in | `user_cubit.dart` |

## Need Help?

See `META_INTEGRATION_FIX.md` for detailed documentation.

## Common Issues

### "Cannot find MetaAnalyticsService"
→ Run the build_runner command above

### "No events showing in Facebook"
→ Check that Test Events mode is enabled in Facebook App settings

### Build fails
→ Run:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

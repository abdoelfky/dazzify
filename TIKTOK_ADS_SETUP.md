# TikTok Ads Integration Guide

## Overview
This app is configured to track events from TikTok Ads (similar to Meta/Facebook Ads) using TikTok Business SDK.

## Current Configuration

### App IDs
- **TikTok API Key (App ID)**: `TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF`
- **TikTok App ID**: `7565017967432450049`

### Platform Status
- ✅ **iOS**: TikTok Business SDK configured and ready
- ✅ **Android**: TikTok App Events SDK configured and ready

---

## Setup Instructions

### 1. Get Your TikTok Access Token

1. Go to [TikTok Ads Manager](https://ads.tiktok.com/)
2. Navigate to **Tools** → **Events**
3. Select your app
4. Copy your **Access Token**

### 2. Configure Access Token

#### Option A: Add to `.env` file (Recommended)
```env
TIKTOK_ACCESS_TOKEN=your_access_token_here
```

#### Option B: Hardcode in iOS (AppDelegate.swift)
Update line 33 in `ios/Runner/AppDelegate.swift`:
```swift
let tiktokAccessToken = "your_access_token_here"  // Replace with your actual token
```

#### Option C: Update dynamically from Flutter
```dart
import 'package:dazzify/core/services/tiktok_sdk_service.dart';

// Update token at runtime
await TikTokSdkService.instance.updateAccessToken('your_access_token_here');
```

---

## Tracked Events

The app automatically tracks the following events:

### Standard Events
- **AppInstall**: When user first installs and opens the app
- **LaunchAPP**: When user launches the app
- **Registration**: When user completes registration
- **ViewContent**: When user views a service
- **AddToCart**: When user adds a service to cart
- **InitiateCheckout**: When user starts checkout
- **Purchase**: When user completes a booking

### Event Parameters
All events include:
- Event type
- Timestamp
- Custom parameters (value, currency, content_id, etc.)

---

## Testing Your Integration

### iOS
1. Enable debug mode (already enabled):
```swift
TikTokBusiness.setDebugMode(true)  // Line 42 in AppDelegate.swift
```

2. Run the app and check Xcode console for:
```
TikTok Business SDK initialized with App ID: 7565017967432450049
TikTok Event tracked: AppInstall with properties: ...
```

### Android
1. Debug mode is already enabled:
```kotlin
.enableDebug(true)  // Line 33 in MainActivity.kt
```

2. Run the app and check Logcat for:
```
TikTok App Events SDK initialized successfully with App ID: TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF
TikTok Event logged successfully: AppInstall - {...}
```

---

## Verify Events in TikTok Ads Manager

1. Go to [TikTok Ads Manager](https://ads.tiktok.com/)
2. Navigate to **Tools** → **Events**
3. Select your app
4. Click on **Test Events** to verify events are being received
5. Check **Event History** for production events

---

## Production Checklist

Before releasing to production:

- [ ] Add your TikTok Access Token (see Setup Instructions above)
- [ ] Disable debug mode in iOS (`TikTokBusiness.setDebugMode(false)`)
- [ ] Disable debug mode in Android (`.enableDebug(false)`)
- [ ] Test all events in TikTok Ads Manager
- [ ] Verify events are showing in TikTok Events dashboard
- [ ] Create TikTok ad campaigns and test conversions

---

## Troubleshooting

### Events not showing in TikTok Ads Manager
1. **Check Access Token**: Make sure it's valid and not expired
2. **Check App ID**: Verify `TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF` matches your TikTok app
3. **Check TikTok App ID**: Verify `7565017967432450049` is correct
4. **Enable Debug Mode**: Check console logs for errors
5. **Wait 24-48 hours**: Sometimes events take time to appear in the dashboard

### iOS-specific issues
- Make sure TikTok Business SDK is installed: `pod 'TikTokBusinessSDK'` in Podfile
- Run `cd ios && pod install` after any changes
- Check Info.plist has correct TikTokAppID and TikTokAppSecret

### Android-specific issues
- Make sure TikTok App Events SDK is in build.gradle: `implementation 'com.tiktok.android:appevents:3.0.1'`
- Check AndroidManifest.xml has correct APP_ID metadata
- Sync Gradle after any changes

---

## Additional Resources

- [TikTok Events API Documentation](https://business-api.tiktok.com/portal/docs?id=1741601162187777)
- [TikTok Business SDK for iOS](https://ads.tiktok.com/marketing_api/docs?id=1739585737180162)
- [TikTok App Events SDK for Android](https://ads.tiktok.com/marketing_api/docs?id=1739585696931842)

---

## Support

For TikTok-specific issues:
- Email: business-support@tiktok.com
- [TikTok Business Help Center](https://ads.tiktok.com/help/)

For app-specific issues:
- Check the Flutter console for error messages
- Review the native logs (Xcode/Logcat)
- Verify your configuration matches this guide

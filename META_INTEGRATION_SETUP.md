# Meta SDK Integration Setup Documentation

## Overview
This document describes the Meta SDK (Facebook SDK) integration implementation for the Dazzify app. The integration enables tracking of app events, user conversions, and provides analytics data to the Meta dashboard.

## Integration Components

### 1. Package Dependencies
- **Package**: `flutter_meta_sdk`
- **Location**: `pubspec.yaml` (line 85)

### 2. Configuration Files

#### iOS Configuration (`ios/Runner/Info.plist`)
Required keys added:
```xml
<key>FacebookAppID</key>
<string>2967524626742822</string>

<key>FacebookClientToken</key>
<string>49cecb36f2affc7f6ed198561f5512c2</string>

<key>FacebookDisplayName</key>
<string>Dazzify</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb2967524626742822</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbapi</string>
    <string>fb-messenger-share-api</string>
    <string>fbauth2</string>
    <string>fbshareextension</string>
</array>
```

**Purpose**: 
- `CFBundleURLTypes`: Enables deep linking from Facebook app to your app
- `LSApplicationQueriesSchemes`: Allows the app to query if Facebook apps are installed

#### Android Configuration

##### `android/app/src/main/res/values/strings.xml`
```xml
<resources>
    <string name="facebook_app_id">2967524626742822</string>
    <string name="facebook_client_token">49cecb36f2affc7f6ed198561f5512c2</string>
</resources>
```

##### `android/app/src/main/AndroidManifest.xml`
Meta-data added inside `<application>` tag:
```xml
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
<meta-data
    android:name="com.facebook.sdk.ClientToken"
    android:value="@string/facebook_client_token"/>
```

Queries added for deep linking:
```xml
<queries>
    <package android:name="com.facebook.katana" />
    <package android:name="com.facebook.orca" />
</queries>
```

### 3. Service Layer (`lib/core/services/meta_sdk_service.dart`)

The `MetaSdkService` class provides a centralized interface for all Meta SDK operations:

#### Key Methods:
- `initialize()`: Initializes the Meta SDK and logs app activation
- `logAppInstall()`: Tracks first-time app installations
- `logCompletedRegistration()`: Tracks user registration completion
- `logPurchase()`: Tracks purchase events
- `logContentView()`: Tracks content views
- `logSearch()`: Tracks search events
- `logAddToCart()`: Tracks add-to-cart actions
- `logAddToWishlist()`: Tracks wishlist additions
- `logInitiatedCheckout()`: Tracks checkout initiation
- `setUserId()`: Sets user ID for tracking
- `setUserData()`: Sets user data for advanced matching
- `clearUserId()`: Clears user ID (on logout)
- `clearUserData()`: Clears user data (on logout)

### 4. Integration Points

#### Main App Initialization (`lib/main.dart`)
```dart
// Initialize Meta SDK for tracking app events and conversions
await MetaSdkService.instance.initialize();
```

#### User Registration (`lib/features/auth/logic/auth_cubit.dart`)
When new user completes registration:
```dart
// Track app install and registration completion for Meta
MetaSdkService.instance.logAppInstall();
MetaSdkService.instance.logCompletedRegistration(
  registrationMethod: 'Phone',
);
// Set user data for advanced matching
MetaSdkService.instance.setUserData(
  email: email,
  firstName: fullName.split(' ').first,
  lastName: fullName.split(' ').length > 1 ? fullName.split(' ').last : null,
);
```

#### User Profile Load (`lib/features/user/logic/user/user_cubit.dart`)
When user profile is loaded:
```dart
// Set user ID in Meta SDK for tracking
MetaSdkService.instance.setUserId(user.id);
// Set user data for advanced matching
MetaSdkService.instance.setUserData(
  email: user.profile.email,
  firstName: user.fullName.split(' ').first,
  lastName: user.fullName.split(' ').length > 1 ? user.fullName.split(' ').last : null,
  phone: user.phoneNumber,
);
```

#### User Logout (`lib/features/shared/logic/tokens/tokens_cubit.dart`)
When user logs out:
```dart
// Clear Meta SDK user data on logout
MetaSdkService.instance.clearUserId();
MetaSdkService.instance.clearUserData();
```

#### User Account Deletion (`lib/features/user/logic/user/user_cubit.dart`)
When user deletes their account:
```dart
// Clear Meta SDK user data when account is deleted
MetaSdkService.instance.clearUserId();
MetaSdkService.instance.clearUserData();
```

## Events Tracked

### Automatic Events
- **App Activation** (`fb_mobile_activate_app`): Tracked automatically when app starts
- **App Install** (`fb_mobile_first_time_purchase`): Tracked on first user registration

### User Events
- **Registration** (`fb_mobile_complete_registration`): Tracked when user completes sign-up
- **User Login**: User ID and data are set for tracking

### Available for Implementation
The following events are available through `MetaSdkService` but need to be implemented at appropriate places:
- Purchase (`fb_mobile_purchase`)
- Content View (`fb_mobile_content_view`)
- Search (`fb_mobile_search`)
- Add to Cart (`fb_mobile_add_to_cart`)
- Add to Wishlist (`fb_mobile_add_to_wishlist`)
- Initiated Checkout (`fb_mobile_initiated_checkout`)

## Troubleshooting

### Common Issues

#### 1. Events Not Showing in Meta Dashboard
**Possible Causes:**
- SDK not initialized properly
- App ID or Client Token incorrect
- Events take 24-48 hours to appear in dashboard
- Test events need to be enabled in Meta Events Manager

**Solution:**
- Verify App ID and Client Token in Meta Business Manager
- Check that `MetaSdkService.instance.initialize()` is called in `main.dart`
- Use Meta Events Manager Test Events feature for debugging

#### 2. Deep Linking Not Working
**iOS:**
- Verify `CFBundleURLSchemes` contains correct Facebook App ID with `fb` prefix
- Check `LSApplicationQueriesSchemes` is properly configured

**Android:**
- Verify `meta-data` tags are inside `<application>` tag
- Check queries section includes Facebook package names

#### 3. User Attribution Issues
**Solution:**
- Ensure `setUserId()` is called after user login
- Verify `setUserData()` is called with correct user information
- Check that user data is cleared on logout

## Meta Dashboard Configuration

### Events Manager
1. Go to Meta Business Manager → Events Manager
2. Select your app
3. View events in the "Test Events" tab during development
4. Check "Aggregated Events" for production data (24-48 hour delay)

### Conversion API
The Meta SDK automatically sends events to the Conversion API for server-side tracking and attribution.

### App Events Dashboard
View detailed analytics:
- Active users
- Event frequency
- User demographics
- Conversion funnels
- Attribution reports

## Testing

### Development Testing
1. Enable "Test Events" in Meta Events Manager
2. Get your test device's Advertiser ID
3. Add device to test devices in Events Manager
4. Install and use the app
5. Verify events appear in Test Events dashboard

### Production Verification
1. After release, wait 24-48 hours
2. Check Aggregated Events in Events Manager
3. Verify event counts and parameters
4. Monitor conversion tracking

## Security Considerations

### Client Token
- Keep client tokens secure
- Don't expose in version control (already in code, consider using environment variables for future)
- Rotate tokens if compromised

### User Data
- User data is hashed before sending to Meta
- GDPR compliance: provide users option to opt-out
- Clear user data on logout/account deletion (already implemented)

## Future Enhancements

### Recommended Implementations
1. **Purchase Tracking**: Integrate with booking/payment flow
2. **Content View Tracking**: Track when users view vendors/services
3. **Search Tracking**: Track search queries
4. **Cart Events**: Track add-to-cart and checkout initiation

### Example: Adding Purchase Tracking
```dart
// In booking completion logic:
await MetaSdkService.instance.logPurchase(
  amount: bookingTotal,
  currency: 'EGP',
  additionalParams: {
    'booking_id': bookingId,
    'vendor_name': vendorName,
  },
);
```

## Support Resources

- [Meta SDK Documentation](https://developers.facebook.com/docs/app-events)
- [Flutter Meta SDK Package](https://pub.dev/packages/flutter_meta_sdk)
- [Meta Events Manager](https://business.facebook.com/events_manager)
- [Meta Business Help Center](https://www.facebook.com/business/help)

## Change Log

### 2025-10-05 - Initial Implementation
- Added Meta SDK package dependency
- Configured iOS and Android platforms
- Created MetaSdkService singleton
- Integrated with authentication flow
- Added user tracking and data management
- Implemented logout and account deletion tracking

---

**Note**: This integration was implemented to resolve the issue where Meta Integration was not working in Meta Dashboard when users downloaded the app. The SDK is now properly initialized and events are being tracked.

# Meta Integration Testing Checklist

## Pre-Testing Setup

- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Run `flutter clean && flutter pub get`
- [ ] Verify Facebook App ID in `android/app/src/main/res/values/strings.xml`: `2967524626742822`
- [ ] Verify Facebook App ID in `ios/Runner/Info.plist`: `2967524626742822`
- [ ] Enable Test Events in Facebook Events Manager

## Test Scenarios

### 1. App Startup
- [ ] Launch the app
- [ ] Check logs for: `✅ Meta SDK initialized successfully`
- [ ] If error appears, check Facebook App ID configuration

### 2. Service View Tracking
**Steps:**
1. [ ] Navigate to home screen
2. [ ] Tap on any service card
3. [ ] View service details page

**Expected Logs:**
```
👁️ Logging Meta view content: [service_id] (service)
📊 Logging Meta event: ViewService with params: {...}
```

**Verify in Facebook Events Manager:**
- [ ] Event name: `ViewContent`
- [ ] Parameters include: content_id, content_type

### 3. Banner/Ad Click Tracking
**Steps:**
1. [ ] Navigate to home screen
2. [ ] Wait for banners to load
3. [ ] Tap on a banner

**Expected Logs:**
```
📊 Logging Meta event: BannerClick with params: {banner_action: ..., banner_index: ...}
```

**Verify in Facebook Events Manager:**
- [ ] Event name: `BannerClick`
- [ ] Parameters include: banner_action, banner_index

### 4. Booking/Purchase Tracking
**Steps:**
1. [ ] Select a service
2. [ ] Choose date and time
3. [ ] Complete booking creation
4. [ ] Submit booking

**Expected Logs:**
```
💰 Logging Meta purchase: [amount] EGP
📊 Logging Meta event: BookingCreated with params: {...}
```

**Verify in Facebook Events Manager:**
- [ ] Event name: `Purchase`
- [ ] Parameters include: value, currency
- [ ] Event name: `BookingCreated`
- [ ] Parameters include: brand_id, num_services, total_amount

### 5. User Login Tracking
**Steps:**
1. [ ] Log out (if logged in)
2. [ ] Enter phone number
3. [ ] Enter OTP code
4. [ ] Complete login

**Expected Logs:**
```
👤 Setting Meta user ID: [user_id]
📊 Logging Meta event: UserLogin with params: {user_id: ..., phone: ...}
```

**Verify in Facebook Events Manager:**
- [ ] Event name: `UserLogin`
- [ ] User ID is set
- [ ] Parameters include: user_id, phone

## Facebook Events Manager Verification

### Access Test Events
1. [ ] Go to https://business.facebook.com/events_manager
2. [ ] Select your app (ID: 2967524626742822)
3. [ ] Click "Test Events" tab
4. [ ] Select your test device

### Expected Events
- [ ] See events appearing in real-time
- [ ] Events have correct parameters
- [ ] User ID is properly set
- [ ] Purchase events have correct currency and amount

## Common Issues & Solutions

### Issue: "No events showing in Facebook"
**Solutions:**
- [ ] Check that app is in Test mode in Facebook
- [ ] Verify Test Events is enabled
- [ ] Check device is selected in Test Events
- [ ] Wait 1-2 minutes for events to appear
- [ ] Check internet connection

### Issue: "Meta SDK initialization failed"
**Solutions:**
- [ ] Verify Facebook App ID and Client Token are correct
- [ ] Check AndroidManifest.xml has correct configuration
- [ ] Check Info.plist has correct configuration
- [ ] Rebuild the app

### Issue: "Build errors about MetaAnalyticsService"
**Solutions:**
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Run `flutter clean && flutter pub get`
- [ ] Check that `flutter_meta_sdk` is in pubspec.yaml

## Production Readiness

Before deploying to production:
- [ ] Test all events on real devices
- [ ] Verify events for 24 hours in Facebook Events Manager
- [ ] Switch Facebook App from Development to Live mode
- [ ] Create Facebook ad campaigns using tracked events
- [ ] Set up conversion tracking for ad optimization
- [ ] Configure ad attribution settings

## Event Monitoring

After deployment, monitor:
- [ ] Event volume (should see events from users)
- [ ] Purchase events match actual bookings
- [ ] User ID tracking is working
- [ ] Ad attribution is working
- [ ] Conversion tracking is accurate

## Success Criteria

✅ All events appear in Facebook Events Manager  
✅ Purchase amounts match booking totals  
✅ User IDs are properly set  
✅ No errors in application logs  
✅ Events appear within 1-2 minutes of action  
✅ Ad attribution works correctly  

## Notes

- Events may take 1-2 minutes to appear in Facebook Events Manager
- Test Events must be enabled for development/testing
- Production events appear in regular Events tab (not Test Events)
- Currency is currently set to 'EGP' - change if needed

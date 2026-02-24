# Meta (Facebook) Key Hashes for Android

## Key Hashes Generated

### Debug Key Hash
```
VJ6wTYj7/rhSOjZ+Uh8/+jwRlWU=
```

### Release Key Hash (Production)
```
QgyggNn0X8S1VzfCfF9O0wpITuw=
```

## How to Add These to Meta App Settings

1. Go to [Facebook Developers Console](https://developers.facebook.com/)
2. Select your app (App ID: `2967524626742822`)
3. Navigate to **Settings** → **Basic**
4. Scroll down to **Android** section
5. Add both key hashes in the **Key Hashes** field:
   - Add the Debug key hash for development/testing
   - Add the Release key hash for production builds
6. Click **Save Changes**

## Notes

- **Debug Key Hash**: Used when running the app in debug mode or during development
- **Release Key Hash**: Used for production/release builds signed with `dazzify-key.jks`
- Both hashes should be added to ensure the app works in both development and production environments

## Regenerating Key Hashes

If you need to regenerate these hashes in the future:

### Debug Key Hash:
```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android | openssl sha1 -binary | openssl base64
```

### Release Key Hash:
```bash
keytool -exportcert -alias dazzifyApp -keystore android/app/dazzify-key.jks -storepass 27112030 -keypass 27112030 | openssl sha1 -binary | openssl base64
```



# 🐴 EquiMind Beta Testing Guide

## For Beta Testers - Quick Access

### Option 1: Direct Link (Fastest)
1. Open **Expo Go** app on your phone
2. Tap the **search bar** at the top
3. Enter or paste: `exp://mental-equestrian-1.preview.emergentagent.com`
4. Tap **Go**
5. The app will load!

**Tip:** Once opened, the app appears in your "Recently opened" section in Expo Go for easy access.

---

### Option 2: QR Code
1. Open **Expo Go** app
2. Tap **"Scan QR code"**
3. Scan the QR code (see attached image: `equimind_app_qr_code.png`)

**Tip:** Save the QR code image to your phone's gallery for future access.

---

## For App Owner - Building Native Apps

### 🍎 iOS TestFlight Distribution

**Prerequisites:**
- Apple Developer Account ($99/year)
- iOS device for testing

**Steps:**

1. **Login to Expo Account**
   ```bash
   cd /app/frontend
   eas login
   ```

2. **Configure the Project**
   ```bash
   eas build:configure
   ```

3. **Update app.json with Bundle Identifier**
   Edit `/app/frontend/app.json`:
   ```json
   {
     "expo": {
       "name": "EquiMind",
       "slug": "equimind",
       "ios": {
         "bundleIdentifier": "com.equimind.app",
         "buildNumber": "1.0.0"
       }
     }
   }
   ```

4. **Build for iOS**
   ```bash
   eas build --platform ios --profile preview
   ```
   
   This creates an `.ipa` file you can distribute via TestFlight.

5. **Submit to TestFlight**
   ```bash
   eas submit --platform ios
   ```
   
   Or manually upload the `.ipa` to App Store Connect.

6. **Share with Beta Testers**
   - Go to App Store Connect
   - Add testers via email
   - They'll receive TestFlight invitation
   - Install TestFlight app and accept invitation
   - Install EquiMind from TestFlight

---

### 🤖 Android Internal Testing (Google Play)

**Prerequisites:**
- Google Play Developer Account ($25 one-time)

**Steps:**

1. **Build APK for Android**
   ```bash
   cd /app/frontend
   eas build --platform android --profile preview
   ```
   
   This creates a standalone `.apk` file.

2. **Download the APK**
   EAS will provide a download link after build completes.

3. **Option A: Direct Distribution**
   - Send the `.apk` file directly to testers
   - Testers enable "Install from Unknown Sources" on Android
   - Install the `.apk`

4. **Option B: Google Play Internal Testing**
   - Go to Google Play Console
   - Create new app
   - Upload `.aab` file (build with `--profile production`)
   - Set up Internal Testing track
   - Add tester emails
   - Share testing link with testers

---

### 📦 Quick Build Commands Reference

```bash
# Login to Expo
eas login

# Configure EAS (first time only)
eas build:configure

# Build iOS preview
eas build --platform ios --profile preview

# Build Android APK
eas build --platform android --profile preview

# Build both platforms
eas build --platform all --profile preview

# Submit to stores (after production build)
eas submit --platform ios
eas submit --platform android
```

---

## Build Profiles Explained

**`preview`** (in eas.json):
- For beta testing
- iOS: Ad-hoc distribution (TestFlight or direct install)
- Android: APK format (easy to share)
- Faster builds

**`production`**:
- For App Store/Play Store release
- Optimized builds
- Required for public distribution

---

## Environment Variables for Builds

Make sure these are set in `/app/frontend/.env`:

```env
EXPO_PUBLIC_BACKEND_URL=https://your-production-backend.com
EXPO_PUBLIC_ADMIN_PASSWORD=your-admin-password
```

These will be bundled into the native app.

---

## Troubleshooting

### Build Fails
- Check that all dependencies are compatible
- Run `npx expo-doctor` to diagnose issues
- Ensure app.json has correct bundle identifiers

### Testers Can't Install
- **iOS:** Ensure UDID is registered (for ad-hoc) or use TestFlight
- **Android:** Enable "Install from Unknown Sources" in device settings

### App Crashes on Launch
- Check backend URL is accessible from mobile network
- Verify MongoDB Atlas allows connections from all IPs (0.0.0.0/0)
- Check logs in EAS dashboard

---

## Cost Summary

| Method | Cost | Ease of Use |
|--------|------|-------------|
| Expo Go (current) | Free | Easy - just QR code |
| TestFlight (iOS) | $99/year | Medium - requires Apple Developer |
| Google Play Internal | $25 one-time | Medium - requires Google account |
| Direct APK | Free | Easy - but less professional |

---

## Recommendations

**For Small Beta (< 10 testers):**
- Use current Expo Go + QR code
- Free and instant

**For Larger Beta (10-100 testers):**
- iOS: TestFlight
- Android: Google Play Internal Testing
- More professional, automatic updates

**For Public Release:**
- Full App Store and Google Play submission
- Use EAS Build with production profile

---

## Next Steps

1. ✅ Share QR code image with beta testers
2. ✅ Share direct link: `exp://mental-equestrian-1.preview.emergentagent.com`
3. If needed: Set up TestFlight/Play Console and build native apps
4. Collect feedback from testers
5. Deploy final version to production

---

**Questions?** Check the [Expo Documentation](https://docs.expo.dev/build/introduction/) or contact support.

# EquiMind App Store & Payment Setup Guide

## Overview
This guide walks you through setting up in-app purchases for your EquiMind app using RevenueCat, Apple App Store, and Google Play Store.

---

## Phase 1: Apple App Store Setup (1-2 hours)

### Step 1.1: Create App in App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"My Apps"** → **"+"** → **"New App"**
3. Fill in:
   - **Platform**: iOS
   - **Name**: EquiMind (or your app name)
   - **Primary Language**: English
   - **Bundle ID**: `com.equimind.app`
   - **SKU**: `equimind-app-001`
4. Click **"Create"**

### Step 1.2: Create Subscription Products
1. In your app, go to **"Subscriptions"** tab
2. Click **"+"** to create a Subscription Group:
   - **Name**: EquiMind Subscriptions
   - **Reference Name**: equimind_subscriptions
3. Click **"Create"** on the subscription group
4. **Add Standard Subscription**:
   - Click **"+"** → **"Create Subscription"**
   - **Reference Name**: standard_monthly
   - **Product ID**: `equimind_standard_monthly`
   - **Subscription Duration**: 1 Month
   - **Price**: $24.99 (Apple will adjust to $25)
   - **Localization**: Add English description
5. **Add Premium Subscription**:
   - Click **"+"** → **"Create Subscription"**
   - **Reference Name**: premium_monthly
   - **Product ID**: `equimind_premium_monthly`
   - **Subscription Duration**: 1 Month
   - **Price**: $34.99 (Apple will adjust to $35)
   - **Localization**: Add English description

### Step 1.3: Create Sandbox Test Account
1. Go to **"Users and Access"** → **"Sandbox"** tab
2. Click **"+"** to add sandbox tester
3. Create a new email (e.g., `test@yourdomain.com`)
4. Set any password (remember it!)
5. Use this account to test purchases without real charges

---

## Phase 2: Google Play Console Setup (1-2 hours)

### Step 2.1: Create App in Google Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Click **"Create app"**
3. Fill in:
   - **App name**: EquiMind
   - **Default language**: English
   - **App or game**: App
   - **Free or paid**: Free (we'll use in-app purchases)
4. Accept policies and click **"Create app"**

### Step 2.2: Create Subscription Products
1. Go to **"Monetization"** → **"Subscriptions"**
2. Click **"Create subscription"**
3. **Add Standard Subscription**:
   - **Product ID**: `equimind_standard_monthly`
   - **Name**: Standard Plan
   - **Description**: Access to all mental performance tools
   - **Benefits**: List your features
   - Click **"Add a base plan"**:
     - **Base plan ID**: standard-monthly
     - **Renewal type**: Auto-renewing
     - **Billing period**: 1 Month
     - **Price**: $25.00
4. **Add Premium Subscription**:
   - **Product ID**: `equimind_premium_monthly`
   - **Name**: Premium Plan
   - **Description**: Full access including courses and downloads
   - **Price**: $35.00

### Step 2.3: Set Up License Testing
1. Go to **"Settings"** → **"License testing"**
2. Add your email addresses for testing
3. These accounts can make test purchases

---

## Phase 3: RevenueCat Configuration (30 minutes)

### Step 3.1: Connect App Stores
1. Go to [RevenueCat Dashboard](https://app.revenuecat.com)
2. Click **"Projects"** → Select your project (or create new)

**Connect Apple:**
1. Go to **"Apps"** → **"+ New App"** → **"App Store"**
2. Enter your **App Bundle ID**: `com.equimind.app`
3. Upload your **App Store Connect API Key**:
   - In App Store Connect → "Users and Access" → "Keys" → "App Store Connect API"
   - Generate new key with "Admin" role
   - Download the .p8 file
   - Upload to RevenueCat

**Connect Google:**
1. Go to **"Apps"** → **"+ New App"** → **"Play Store"**
2. Enter your **Package Name**: `com.equimind.app`
3. Upload your **Google Play Service Account JSON**:
   - In Google Cloud Console, create service account
   - Grant "Pub/Sub Admin" role
   - Download JSON key
   - Upload to RevenueCat

### Step 3.2: Create Entitlements
1. Go to **"Entitlements"** → **"+ New"**
2. Create **"standard"** entitlement:
   - Identifier: `standard`
   - Description: Standard plan access
3. Create **"premium"** entitlement:
   - Identifier: `premium`
   - Description: Premium plan access (includes standard)

### Step 3.3: Create Products
1. Go to **"Products"** → **"+ New"**
2. Add each subscription:
   - `equimind_standard_monthly` → Link to "standard" entitlement
   - `equimind_premium_monthly` → Link to "premium" entitlement

### Step 3.4: Create Offerings
1. Go to **"Offerings"** → **"+ New"**
2. Create **"default"** offering:
   - Add **"Standard"** package with standard product
   - Add **"Premium"** package with premium product

### Step 3.5: Set Up Webhook
1. Go to **"Integrations"** → **"Webhooks"**
2. Click **"+ Add New"**
3. Enter:
   - **URL**: `https://equimind-ride.emergent.host/api/subscriptions/webhook/revenuecat`
   - **Authorization**: Leave empty (we handle it)
4. Select events to send:
   - ✅ Initial Purchase
   - ✅ Renewal
   - ✅ Cancellation
   - ✅ Expiration
   - ✅ Billing Issue
5. Click **"Save"**

### Step 3.6: Get Production API Key
1. Go to **"API Keys"**
2. Copy your **Public App-Specific API Key** (starts with `appl_` or `goog_`)
3. **Important**: Replace the test key in your app with this production key

---

## Phase 4: Update Your App (15 minutes)

### Step 4.1: Update RevenueCat API Key
Replace the test key with your production key:

**In Admin Dashboard** (if you have env variable management):
- Set `EXPO_PUBLIC_REVENUECAT_API_KEY` to your production key

**Or in code** (`frontend/lib/purchases.ts`):
```typescript
const REVENUECAT_API_KEY = 'YOUR_PRODUCTION_API_KEY';
```

### Step 4.2: Deploy Updated App
1. Deploy from Emergent dashboard
2. Test with sandbox/test accounts before going live

---

## Phase 5: Testing Checklist

### Before Submission:
- [ ] Test Standard subscription purchase (sandbox)
- [ ] Test Premium subscription purchase (sandbox)
- [ ] Verify Premium Content unlocks after purchase
- [ ] Test on both iOS and Android
- [ ] Verify webhook receives events (check backend logs)

### Test Flow:
1. Log into app with test account
2. Tap "Upgrade to Premium"
3. Complete purchase with sandbox account
4. Verify home page shows "Premium Plan"
5. Verify "Premium Content" is accessible
6. Check admin dashboard shows subscription data

---

## Phase 6: App Store Submission Prep

### Required Assets:
1. **App Icon**: 1024x1024 PNG (no alpha/transparency)
2. **Screenshots**:
   - iPhone: 6.7" (1290 x 2796), 6.5" (1284 x 2778), 5.5" (1242 x 2208)
   - iPad: 12.9" (2048 x 2732)
3. **App Preview Video** (optional): 15-30 seconds

### Required Information:
1. **App Description**: What your app does
2. **Keywords**: For search (100 chars max)
3. **Support URL**: Your website or email
4. **Privacy Policy URL**: Required for subscriptions
5. **Categories**: Choose primary & secondary

### Subscription Metadata:
1. **Subscription Group Display Name**
2. **App Store promotional image** (optional)

---

## Quick Reference

### Important URLs:
- App Store Connect: https://appstoreconnect.apple.com
- Google Play Console: https://play.google.com/console
- RevenueCat Dashboard: https://app.revenuecat.com

### Your App Details:
- **Bundle ID (iOS)**: `com.equimind.app`
- **Package Name (Android)**: `com.equimind.app`
- **RevenueCat Webhook URL**: `https://equimind-ride.emergent.host/api/subscriptions/webhook/revenuecat`

### Product IDs:
- Standard: `equimind_standard_monthly`
- Premium: `equimind_premium_monthly`

---

## Need Help?

- **RevenueCat Docs**: https://docs.revenuecat.com
- **Apple IAP Guide**: https://developer.apple.com/in-app-purchase/
- **Google Billing**: https://developer.android.com/google/play/billing

Good luck with your app launch! 🚀

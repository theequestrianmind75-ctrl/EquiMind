import Purchases, { LOG_LEVEL, PurchasesPackage } from 'react-native-purchases';
import { Platform } from 'react-native';

// RevenueCat API Key - read from environment variable
const REVENUECAT_API_KEY = process.env.EXPO_PUBLIC_REVENUECAT_API_KEY || 'test_NWSVzbWbKJdupmAVRHZrFxXQeaj';

export const configurePurchases = async () => {
  try {
    if (Platform.OS === 'ios' || Platform.OS === 'android') {
      Purchases.setLogLevel(LOG_LEVEL.DEBUG);
      await Purchases.configure({ apiKey: REVENUECAT_API_KEY });
      console.log('✅ RevenueCat configured successfully');
    } else {
      console.log('⚠️ RevenueCat only works on iOS/Android, skipping for web');
    }
  } catch (error) {
    console.error('❌ Error configuring RevenueCat:', error);
  }
};

export const getOfferings = async (): Promise<PurchasesPackage[]> => {
  try {
    const offerings = await Purchases.getOfferings();
    if (offerings.current !== null && offerings.current.availablePackages.length > 0) {
      return offerings.current.availablePackages;
    }
    return [];
  } catch (error) {
    console.error('Error fetching offerings:', error);
    return [];
  }
};

export const purchasePackage = async (packageToPurchase: PurchasesPackage) => {
  try {
    const { customerInfo } = await Purchases.purchasePackage(packageToPurchase);
    
    // Check if user has premium entitlement
    if (typeof customerInfo.entitlements.active['premium'] !== 'undefined') {
      return { success: true, isPremium: true };
    }
    
    return { success: true, isPremium: false };
  } catch (error: any) {
    if (error.userCancelled) {
      return { success: false, error: 'User cancelled' };
    }
    return { success: false, error: error.message };
  }
};

export const restorePurchases = async () => {
  try {
    const customerInfo = await Purchases.restorePurchases();
    const isPremium = typeof customerInfo.entitlements.active['premium'] !== 'undefined';
    return { success: true, isPremium };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
};

export const checkSubscriptionStatus = async () => {
  try {
    const customerInfo = await Purchases.getCustomerInfo();
    const isPremium = typeof customerInfo.entitlements.active['premium'] !== 'undefined';
    const isStandard = typeof customerInfo.entitlements.active['standard'] !== 'undefined';
    
    return {
      isPremium,
      isStandard,
      hasAnySubscription: isPremium || isStandard,
    };
  } catch (error) {
    console.error('Error checking subscription:', error);
    return {
      isPremium: false,
      isStandard: false,
      hasAnySubscription: false,
    };
  }
};

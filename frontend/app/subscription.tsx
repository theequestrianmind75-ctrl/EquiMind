import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Alert,
  Platform,
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';
import { 
  getOfferings, 
  purchasePackage
} from '../lib/purchases';
import { PurchasesPackage } from 'react-native-purchases';

type SubscriptionTier = {
  tier_id: string;
  name: string;
  price_monthly: number;
  price_display: string;
  features: string[];
  description: string;
  badge?: string;
};

export default function Subscription() {
  const router = useRouter();
  const [tiers, setTiers] = useState<SubscriptionTier[]>([]);
  const [packages, setPackages] = useState<PurchasesPackage[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTier, setSelectedTier] = useState<string | null>(null);
  const [subscribing, setSubscribing] = useState(false);
  const [isNativePlatform, setIsNativePlatform] = useState(false);

  useEffect(() => {
    // Check if running on native platform (iOS/Android)
    const isNative = Platform.OS === 'ios' || Platform.OS === 'android';
    setIsNativePlatform(isNative);
    
    loadSubscriptionData(isNative);
  }, []);

  const loadSubscriptionData = async (isNative: boolean) => {
    try {
      // Load tier info from backend (for feature list display)
      const response = await api.get('/subscriptions/tiers');
      setTiers(response.data);
      
      // If on native platform, also try to load RevenueCat packages
      if (isNative) {
        try {
          const rcPackages = await getOfferings();
          setPackages(rcPackages);
          console.log('📦 RevenueCat packages:', rcPackages.length);
        } catch (rcError) {
          console.log('⚠️ RevenueCat not available (expected in development):', rcError);
        }
      }
    } catch (error) {
      console.error('Error loading subscription data:', error);
      Alert.alert('Error', 'Failed to load subscription options');
    } finally {
      setLoading(false);
    }
  };

  const handleSubscribe = async (tierId: string) => {
    setSubscribing(true);
    try {
      // Check if we have RevenueCat packages available
      if (packages.length > 0) {
        // Find the matching package (premium)
        const premiumPackage = packages.find(
          pkg => pkg.identifier.toLowerCase().includes('premium') || 
                 pkg.identifier.toLowerCase().includes('monthly')
        ) || packages[0];
        
        if (premiumPackage) {
          console.log('🛒 Starting purchase for:', premiumPackage.identifier);
          const result = await purchasePackage(premiumPackage);
          
          if (result.success) {
            // Update backend with subscription status
            await updateSubscription(tierId);
            
            Alert.alert(
              '🎉 Welcome to Premium!',
              'Your subscription has been activated. Enjoy full access to all premium content.',
              [
                {
                  text: 'Start Exploring',
                  onPress: () => router.push('/(tabs)/home'),
                },
              ]
            );
          } else if (result.error === 'User cancelled') {
            // User cancelled - do nothing
            console.log('User cancelled purchase');
          } else {
            Alert.alert('Purchase Failed', result.error || 'An error occurred during purchase.');
          }
        } else {
          // No matching package found
          showDevelopmentAlert(tierId);
        }
      } else {
        // No packages available (development mode or web)
        showDevelopmentAlert(tierId);
      }
    } catch (error) {
      console.error('Error subscribing:', error);
      Alert.alert('Error', 'Failed to process subscription. Please try again.');
    } finally {
      setSubscribing(false);
    }
  };

  const showDevelopmentAlert = (tierId: string) => {
    Alert.alert(
      'In-App Purchase',
      Platform.OS === 'web' 
        ? 'Subscriptions are available in the mobile app (iOS/Android). Please download the app from the App Store or Google Play to subscribe.'
        : 'In-app purchases will be available once the app is published to the App Store. For testing purposes, we can activate your subscription now.',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: Platform.OS === 'web' ? 'OK' : 'Activate for Testing',
          onPress: () => {
            if (Platform.OS !== 'web') {
              updateSubscription(tierId);
            }
          },
        },
      ]
    );
  };

  const updateSubscription = async (tierId: string) => {
    try {
      await api.post('/subscriptions/update', {
        subscription_tier: tierId,
        subscription_status: 'active',
        subscription_start_date: new Date().toISOString(),
      });

      Alert.alert(
        'Success!',
        'Your subscription has been activated.',
        [
          {
            text: 'Start Using App',
            onPress: () => router.push('/(tabs)/home'),
          },
        ]
      );
    } catch (error) {
      console.error('Error updating subscription:', error);
      Alert.alert('Error', 'Failed to activate subscription');
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
          <Text style={styles.loadingText}>Loading subscription options...</Text>
        </View>
      </SafeAreaView>
    );
  }

  // Get the premium tier for display
  const premiumTier = tiers.find(tier => tier.tier_id === 'premium');

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.topHeader}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000000" />
        </TouchableOpacity>
        <Text style={styles.topHeaderTitle}>Upgrade to Premium</Text>
        <View style={{ width: 40 }} />
      </View>
      
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <View style={styles.iconContainer}>
            <Image 
              source={require('../assets/images/equimind-icon.png')}
              style={styles.horseLogo}
            />
          </View>
          <Text style={styles.title}>Unlock Premium</Text>
          <Text style={styles.subtitle}>
            Get access to exclusive content and advanced features
          </Text>
        </View>

        {premiumTier && (
          <View style={styles.tierCard}>
            <View style={styles.priceContainer}>
              <Text style={styles.priceAmount}>{premiumTier.price_display}</Text>
              <Text style={styles.pricePeriod}>per month</Text>
            </View>
            
            <Text style={styles.tierDescription}>{premiumTier.description}</Text>

            <View style={styles.featuresContainer}>
              <Text style={styles.featuresTitle}>Premium includes:</Text>
              {premiumTier.features.map((feature, index) => (
                <View key={index} style={styles.featureRow}>
                  <Ionicons name="checkmark-circle" size={22} color="#10b981" />
                  <Text style={styles.featureText}>{feature}</Text>
                </View>
              ))}
            </View>
          </View>
        )}

        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={[
              styles.subscribeButton,
              subscribing && styles.subscribeButtonDisabled,
            ]}
            onPress={() => handleSubscribe('premium')}
            disabled={subscribing}
          >
            {subscribing ? (
              <ActivityIndicator color="#ffffff" />
            ) : (
              <>
                <Ionicons name="star" size={24} color="#ffffff" />
                <Text style={styles.subscribeButtonText}>
                  Subscribe to Premium
                </Text>
              </>
            )}
          </TouchableOpacity>
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>
            Subscriptions are billed monthly and can be cancelled anytime.
            Payment will be charged to your {Platform.OS === 'ios' ? 'Apple ID' : Platform.OS === 'android' ? 'Google Play' : 'App Store'} account.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f7fa',
  },
  topHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    backgroundColor: '#ffffff',
    borderBottomWidth: 1,
    borderBottomColor: '#e2e8f0',
  },
  backButton: {
    padding: 8,
  },
  topHeaderTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#000000',
  },
  scrollView: {
    flex: 1,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#718096',
  },
  header: {
    alignItems: 'center',
    padding: 32,
    paddingBottom: 24,
  },
  iconContainer: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: '#fef3c7',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#718096',
    textAlign: 'center',
    lineHeight: 24,
  },
  tierCard: {
    backgroundColor: '#ffffff',
    marginHorizontal: 16,
    borderRadius: 16,
    padding: 24,
    borderWidth: 2,
    borderColor: '#f59e0b',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
  },
  priceContainer: {
    alignItems: 'center',
    marginBottom: 16,
    paddingBottom: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#e2e8f0',
  },
  priceAmount: {
    fontSize: 42,
    fontWeight: 'bold',
    color: '#375B50',
  },
  pricePeriod: {
    fontSize: 16,
    color: '#718096',
    marginTop: 4,
  },
  tierDescription: {
    fontSize: 15,
    color: '#4a5568',
    textAlign: 'center',
    marginBottom: 20,
    lineHeight: 22,
  },
  featuresContainer: {
    gap: 12,
  },
  featuresTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#2d3748',
    marginBottom: 8,
  },
  featureRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  featureText: {
    flex: 1,
    fontSize: 15,
    color: '#4a5568',
    lineHeight: 22,
  },
  buttonContainer: {
    padding: 16,
    paddingTop: 24,
  },
  subscribeButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    padding: 18,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
    shadowColor: '#375B50',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 4,
  },
  subscribeButtonDisabled: {
    backgroundColor: '#94a3b8',
    shadowOpacity: 0,
  },
  subscribeButtonText: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: '700',
  },
  restoreButton: {
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 8,
  },
  restoreButtonText: {
    color: '#375B50',
    fontSize: 16,
    fontWeight: '600',
  },
  footer: {
    padding: 24,
    alignItems: 'center',
  },
  footerText: {
    fontSize: 13,
    color: '#94a3b8',
    textAlign: 'center',
    lineHeight: 20,
    marginBottom: 16,
  },
  footerLinks: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  footerLink: {
    fontSize: 13,
    color: '#375B50',
    fontWeight: '500',
  },
  footerDivider: {
    color: '#94a3b8',
  },
});

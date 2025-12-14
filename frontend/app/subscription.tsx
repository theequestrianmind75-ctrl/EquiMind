import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

interface SubscriptionTier {
  tier_id: string;
  name: string;
  price_monthly: number;
  price_display: string;
  features: string[];
  description: string;
  badge?: string;
}

export default function Subscription() {
  const router = useRouter();
  const [tiers, setTiers] = useState<SubscriptionTier[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTier, setSelectedTier] = useState<string | null>(null);
  const [subscribing, setSubscribing] = useState(false);

  useEffect(() => {
    loadSubscriptionTiers();
  }, []);

  const loadSubscriptionTiers = async () => {
    try {
      const response = await api.get('/subscriptions/tiers');
      setTiers(response.data);
    } catch (error) {
      console.error('Error loading subscription tiers:', error);
      Alert.alert('Error', 'Failed to load subscription options');
    } finally {
      setLoading(false);
    }
  };

  const handleSubscribe = async (tierId: string) => {
    setSubscribing(true);
    try {
      // TODO: Integrate with Apple/Google in-app purchase
      // For now, we'll simulate subscription
      Alert.alert(
        'Coming Soon',
        'In-app purchases will be available once the app is published to the App Store. For now, you can explore the app freely.',
        [
          {
            text: 'OK',
            onPress: () => {
              // Temporarily grant access for testing
              updateSubscription(tierId);
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error subscribing:', error);
      Alert.alert('Error', 'Failed to process subscription');
    } finally {
      setSubscribing(false);
    }
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

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <Ionicons name="ribbon" size={64} color="#375B50" />
          <Text style={styles.title}>Choose Your Plan</Text>
          <Text style={styles.subtitle}>
            Start your mental performance journey
          </Text>
        </View>

        <View style={styles.tiersContainer}>
          {tiers.map((tier) => (
            <TouchableOpacity
              key={tier.tier_id}
              style={[
                styles.tierCard,
                selectedTier === tier.tier_id && styles.tierCardSelected,
                tier.badge && styles.tierCardPremium,
              ]}
              onPress={() => setSelectedTier(tier.tier_id)}
              activeOpacity={0.8}
            >
              {tier.badge && (
                <View style={styles.badge}>
                  <Text style={styles.badgeText}>{tier.badge}</Text>
                </View>
              )}

              <View style={styles.tierHeader}>
                <Text style={styles.tierName}>{tier.name}</Text>
                <Text style={styles.tierPrice}>{tier.price_display}</Text>
                <Text style={styles.tierDescription}>{tier.description}</Text>
              </View>

              <View style={styles.featuresContainer}>
                {tier.features.map((feature, index) => (
                  <View key={index} style={styles.featureRow}>
                    <Ionicons name="checkmark-circle" size={20} color="#375B50" />
                    <Text style={styles.featureText}>{feature}</Text>
                  </View>
                ))}
              </View>

              {selectedTier === tier.tier_id && (
                <View style={styles.selectedIndicator}>
                  <Ionicons name="checkmark-circle" size={24} color="#375B50" />
                  <Text style={styles.selectedText}>Selected</Text>
                </View>
              )}
            </TouchableOpacity>
          ))}
        </View>

        <TouchableOpacity
          style={[
            styles.subscribeButton,
            !selectedTier && styles.subscribeButtonDisabled,
          ]}
          onPress={() => selectedTier && handleSubscribe(selectedTier)}
          disabled={!selectedTier || subscribing}
        >
          {subscribing ? (
            <ActivityIndicator color="#ffffff" />
          ) : (
            <>
              <Text style={styles.subscribeButtonText}>Continue</Text>
              <Ionicons name="arrow-forward" size={24} color="#ffffff" />
            </>
          )}
        </TouchableOpacity>

        <View style={styles.footer}>
          <Text style={styles.footerText}>
            • Cancel anytime{'\n'}
            • Secure payment via Apple/Google{'\n'}
            • 7-day money-back guarantee
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
    paddingTop: 48,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#000000',
    marginTop: 16,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#718096',
    textAlign: 'center',
  },
  tiersContainer: {
    padding: 16,
    gap: 16,
  },
  tierCard: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 24,
    borderWidth: 2,
    borderColor: '#e2e8f0',
    position: 'relative',
  },
  tierCardSelected: {
    borderColor: '#375B50',
    borderWidth: 3,
  },
  tierCardPremium: {
    backgroundColor: '#f0fdf4',
  },
  badge: {
    position: 'absolute',
    top: -12,
    right: 24,
    backgroundColor: '#375B50',
    paddingHorizontal: 16,
    paddingVertical: 6,
    borderRadius: 12,
  },
  badgeText: {
    color: '#ffffff',
    fontSize: 12,
    fontWeight: '700',
    textTransform: 'uppercase',
  },
  tierHeader: {
    marginBottom: 24,
  },
  tierName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 8,
  },
  tierPrice: {
    fontSize: 36,
    fontWeight: 'bold',
    color: '#375B50',
    marginBottom: 8,
  },
  tierDescription: {
    fontSize: 14,
    color: '#718096',
  },
  featuresContainer: {
    gap: 12,
  },
  featureRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  featureText: {
    flex: 1,
    fontSize: 15,
    color: '#2d3748',
  },
  selectedIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#e2e8f0',
    gap: 8,
  },
  selectedText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#375B50',
  },
  subscribeButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    marginHorizontal: 16,
    marginTop: 8,
    padding: 18,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  subscribeButtonDisabled: {
    backgroundColor: '#cbd5e0',
  },
  subscribeButtonText: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: '700',
  },
  footer: {
    padding: 24,
    alignItems: 'center',
  },
  footerText: {
    fontSize: 14,
    color: '#718096',
    textAlign: 'center',
    lineHeight: 20,
  },
});

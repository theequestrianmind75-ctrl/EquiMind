import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Linking,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as WebBrowser from 'expo-web-browser';
import api from '../lib/api';

export default function PremiumContent() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [subscriptionStatus, setSubscriptionStatus] = useState(null);

  useEffect(() => {
    checkSubscription();
  }, []);

  const checkSubscription = async () => {
    try {
      const response = await api.get('/subscriptions/status');
      setSubscriptionStatus(response.data);
      
      if (response.data.subscription_tier !== 'premium') {
        Alert.alert(
          'Premium Required',
          'This content is only available with a Premium subscription ($35/month)',
          [
            { text: 'Upgrade', onPress: () => router.push('/subscription') },
            { text: 'Cancel', onPress: () => router.back() },
          ]
        );
      }
    } catch (error) {
      console.error('Error checking subscription:', error);
    } finally {
      setLoading(false);
    }
  };

  const openThinkific = async () => {
    try {
      await WebBrowser.openBrowserAsync(
        'https://kristi-s-site-43fb.thinkific.com/bundles/my-membership',
        {
          presentationStyle: WebBrowser.WebBrowserPresentationStyle.FULL_SCREEN,
          controlsColor: '#375B50',
        }
      );
    } catch (error) {
      console.error('Error opening Thinkific:', error);
      Alert.alert('Error', 'Failed to open course content');
    }
  };

  const openAmazonBook = async () => {
    try {
      await Linking.openURL(
        'https://www.amazon.com/Equestrian-Mind-performance-riders-Champion/dp/B0F84JPHT5'
      );
    } catch (error) {
      console.error('Error opening Amazon:', error);
      Alert.alert('Error', 'Failed to open book link');
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
        </View>
      </SafeAreaView>
    );
  }

  const isPremium = subscriptionStatus?.subscription_tier === 'premium';

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000000" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Premium Content</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Subscription Status */}
        <View style={styles.statusCard}>
          <View style={styles.statusHeader}>
            <Ionicons 
              name={isPremium ? "checkmark-circle" : "lock-closed"} 
              size={32} 
              color={isPremium ? "#10b981" : "#f59e0b"} 
            />
            <View style={styles.statusTextContainer}>
              <Text style={styles.statusTitle}>
                {isPremium ? 'Premium Active' : 'Standard Plan'}
              </Text>
              <Text style={styles.statusSubtitle}>
                {isPremium 
                  ? 'You have access to all premium content' 
                  : 'Upgrade to Premium for exclusive content'}
              </Text>
            </View>
          </View>
          {!isPremium && (
            <TouchableOpacity 
              style={styles.upgradeButton}
              onPress={() => router.push('/subscription')}
            >
              <Text style={styles.upgradeButtonText}>Upgrade to Premium</Text>
            </TouchableOpacity>
          )}
        </View>

        {/* Courses & Downloads Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Video Courses & Digital Downloads</Text>
          <Text style={styles.sectionDescription}>
            Access all courses, guides, and training materials
          </Text>

          <TouchableOpacity
            style={[styles.contentCard, !isPremium && styles.contentCardLocked]}
            onPress={isPremium ? openThinkific : () => router.push('/subscription')}
          >
            <View style={styles.contentIcon}>
              <Ionicons name="school" size={32} color="#375B50" />
            </View>
            <View style={styles.contentInfo}>
              <Text style={styles.contentTitle}>The Equestrian Mind Courses</Text>
              <Text style={styles.contentDescription}>
                • The Equestrian Mindset{'\n'}
                • Break your Perfectionism{'\n'}
                • When You Shouldn&apos;t Ride Due to Emotions{'\n'}
                • Plus 7 Digital Downloads & Guides
              </Text>
            </View>
            <Ionicons 
              name={isPremium ? "arrow-forward" : "lock-closed"} 
              size={24} 
              color={isPremium ? "#375B50" : "#cbd5e0"} 
            />
          </TouchableOpacity>

          {!isPremium && (
            <View style={styles.lockMessage}>
              <Ionicons name="information-circle" size={20} color="#f59e0b" />
              <Text style={styles.lockMessageText}>
                Unlock with Premium ($35/month)
              </Text>
            </View>
          )}
        </View>

        {/* Book Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>The Equestrian Mind Book</Text>
          <Text style={styles.sectionDescription}>
            Available separately on Amazon
          </Text>

          <TouchableOpacity
            style={styles.bookCard}
            onPress={openAmazonBook}
          >
            <View style={styles.bookIcon}>
              <Ionicons name="book" size={32} color="#ff9900" />
            </View>
            <View style={styles.contentInfo}>
              <Text style={styles.contentTitle}>Master Your Ride</Text>
              <Text style={styles.contentDescription}>
                The complete guide to mental mastery in equestrian sports
              </Text>
              <View style={styles.priceTag}>
                <Text style={styles.priceText}>$25 on Amazon</Text>
              </View>
            </View>
            <Ionicons name="arrow-forward" size={24} color="#ff9900" />
          </TouchableOpacity>
        </View>

        {/* FAQ */}
        <View style={styles.faqSection}>
          <Text style={styles.faqTitle}>Frequently Asked Questions</Text>
          
          <View style={styles.faqItem}>
            <Text style={styles.faqQuestion}>What&apos;s included in Premium?</Text>
            <Text style={styles.faqAnswer}>
              Premium includes all Standard features plus access to video courses and digital downloads via Thinkific.
            </Text>
          </View>

          <View style={styles.faqItem}>
            <Text style={styles.faqQuestion}>How do I access the courses?</Text>
            <Text style={styles.faqAnswer}>
              Click the course button above. You&apos;ll be taken to Thinkific where you can create an account and access all content.
            </Text>
          </View>

          <View style={styles.faqItem}>
            <Text style={styles.faqQuestion}>Is the book included?</Text>
            <Text style={styles.faqAnswer}>
              No, the physical/Kindle book is sold separately on Amazon for $25.
            </Text>
          </View>
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
  header: {
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
  headerTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#000000',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  scrollView: {
    flex: 1,
  },
  statusCard: {
    backgroundColor: '#ffffff',
    margin: 16,
    padding: 20,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  statusHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16,
  },
  statusTextContainer: {
    flex: 1,
  },
  statusTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 4,
  },
  statusSubtitle: {
    fontSize: 14,
    color: '#718096',
  },
  upgradeButton: {
    backgroundColor: '#375B50',
    marginTop: 16,
    padding: 14,
    borderRadius: 8,
    alignItems: 'center',
  },
  upgradeButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600',
  },
  section: {
    marginHorizontal: 16,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 8,
  },
  sectionDescription: {
    fontSize: 14,
    color: '#718096',
    marginBottom: 16,
  },
  contentCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    gap: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  contentCardLocked: {
    opacity: 0.6,
  },
  contentIcon: {
    width: 56,
    height: 56,
    backgroundColor: '#f0fdf4',
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  contentInfo: {
    flex: 1,
  },
  contentTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 6,
  },
  contentDescription: {
    fontSize: 14,
    color: '#718096',
    lineHeight: 20,
  },
  lockMessage: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 12,
    gap: 8,
  },
  lockMessageText: {
    fontSize: 14,
    color: '#f59e0b',
    fontWeight: '600',
  },
  bookCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    gap: 16,
    borderWidth: 2,
    borderColor: '#ff9900',
  },
  bookIcon: {
    width: 56,
    height: 56,
    backgroundColor: '#fff7ed',
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  priceTag: {
    backgroundColor: '#ff9900',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 6,
    alignSelf: 'flex-start',
    marginTop: 8,
  },
  priceText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
  faqSection: {
    backgroundColor: '#ffffff',
    margin: 16,
    padding: 20,
    borderRadius: 12,
  },
  faqTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 16,
  },
  faqItem: {
    marginBottom: 16,
  },
  faqQuestion: {
    fontSize: 15,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 6,
  },
  faqAnswer: {
    fontSize: 14,
    color: '#718096',
    lineHeight: 20,
  },
});

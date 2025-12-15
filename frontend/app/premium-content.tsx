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
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as WebBrowser from 'expo-web-browser';
import api from '../lib/api';

// Thinkific site configuration
const THINKIFIC_URL = 'https://kristi-s-site-43fb.thinkific.com';

type ContentItem = {
  id: string;
  content_type: string;
  title: string;
  description: string;
  icon: string;
  color: string;
  url: string;
  duration?: string;
  order: number;
  active: boolean;
};

type SubscriptionStatus = {
  user_id: string;
  subscription_tier: string;
  subscription_status: string;
  has_access: boolean;
} | null;

export default function PremiumContent() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [subscriptionStatus, setSubscriptionStatus] = useState<SubscriptionStatus>(null);
  const [courses, setCourses] = useState<ContentItem[]>([]);
  const [downloads, setDownloads] = useState<ContentItem[]>([]);
  const [activeTab, setActiveTab] = useState<'courses' | 'downloads'>('courses');

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      // Load subscription status and premium content in parallel
      const [subResponse, contentResponse] = await Promise.all([
        api.get('/subscriptions/status'),
        api.get('/premium-content')
      ]);
      
      setSubscriptionStatus(subResponse.data);
      setCourses(contentResponse.data.courses || []);
      setDownloads(contentResponse.data.downloads || []);
      
      if (subResponse.data.subscription_tier !== 'premium') {
        Alert.alert(
          'Premium Required',
          'This content is only available with a Premium subscription ($35/month)',
          [
            { text: 'Upgrade Now', onPress: () => router.push('/subscription') },
            { text: 'Maybe Later', onPress: () => router.back() },
          ]
        );
      }
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      setLoading(false);
    }
  };

  const openThinkificContent = async (url: string, title: string) => {
    if (!isPremium) {
      Alert.alert(
        'Premium Required',
        `"${title}" requires a Premium subscription.`,
        [
          { text: 'Upgrade', onPress: () => router.push('/subscription') },
          { text: 'Cancel', style: 'cancel' },
        ]
      );
      return;
    }

    try {
      await WebBrowser.openBrowserAsync(url, {
        presentationStyle: WebBrowser.WebBrowserPresentationStyle.FULL_SCREEN,
        controlsColor: '#375B50',
        toolbarColor: '#ffffff',
      });
    } catch (error) {
      console.error('Error opening content:', error);
      // Fallback to Linking if WebBrowser fails
      Linking.openURL(url);
    }
  };

  const openThinkificHome = async () => {
    try {
      await WebBrowser.openBrowserAsync(THINKIFIC_URL, {
        presentationStyle: WebBrowser.WebBrowserPresentationStyle.FULL_SCREEN,
        controlsColor: '#375B50',
      });
    } catch (error) {
      Linking.openURL(THINKIFIC_URL);
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
          <Text style={styles.loadingText}>Loading premium content...</Text>
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
        <TouchableOpacity onPress={openThinkificHome} style={styles.backButton}>
          <Ionicons name="globe-outline" size={24} color="#375B50" />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Subscription Status Banner */}
        <View style={[styles.statusBanner, isPremium ? styles.statusBannerPremium : styles.statusBannerStandard]}>
          <View style={styles.statusContent}>
            <Ionicons 
              name={isPremium ? "star" : "lock-closed"} 
              size={28} 
              color={isPremium ? "#f59e0b" : "#ffffff"} 
            />
            <View style={styles.statusTextContainer}>
              <Text style={styles.statusTitle}>
                {isPremium ? '⭐ Premium Member' : '🔒 Standard Plan'}
              </Text>
              <Text style={styles.statusSubtitle}>
                {isPremium 
                  ? 'Full access to all courses & downloads' 
                  : 'Upgrade to unlock all content'}
              </Text>
            </View>
          </View>
          {!isPremium && (
            <TouchableOpacity 
              style={styles.upgradeBannerButton}
              onPress={() => router.push('/subscription')}
            >
              <Text style={styles.upgradeBannerButtonText}>Upgrade</Text>
              <Ionicons name="arrow-forward" size={16} color="#375B50" />
            </TouchableOpacity>
          )}
        </View>

        {/* Tab Navigation */}
        <View style={styles.tabContainer}>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'courses' && styles.tabActive]}
            onPress={() => setActiveTab('courses')}
          >
            <Ionicons 
              name="school" 
              size={20} 
              color={activeTab === 'courses' ? '#375B50' : '#718096'} 
            />
            <Text style={[styles.tabText, activeTab === 'courses' && styles.tabTextActive]}>
              Courses
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'downloads' && styles.tabActive]}
            onPress={() => setActiveTab('downloads')}
          >
            <Ionicons 
              name="download" 
              size={20} 
              color={activeTab === 'downloads' ? '#375B50' : '#718096'} 
            />
            <Text style={[styles.tabText, activeTab === 'downloads' && styles.tabTextActive]}>
              Downloads
            </Text>
          </TouchableOpacity>
        </View>

        {/* Courses Tab */}
        {activeTab === 'courses' && (
          <View style={styles.contentSection}>
            <Text style={styles.sectionTitle}>Video Courses</Text>
            <Text style={styles.sectionDescription}>
              In-depth training programs for mental mastery
            </Text>

            {courses.length === 0 ? (
              <View style={styles.emptyState}>
                <Ionicons name="school-outline" size={48} color="#cbd5e0" />
                <Text style={styles.emptyStateText}>No courses available yet</Text>
                <Text style={styles.emptyStateSubtext}>Check back soon for new content!</Text>
              </View>
            ) : (
              courses.map((course) => (
                <TouchableOpacity
                  key={course.id}
                  style={[styles.courseCard, !isPremium && styles.cardLocked]}
                  onPress={() => openThinkificContent(course.url, course.title)}
                  activeOpacity={0.7}
                >
                  <View style={[styles.courseIcon, { backgroundColor: (course.color || '#375B50') + '20' }]}>
                    <Ionicons name={(course.icon || 'book') as any} size={28} color={course.color || '#375B50'} />
                  </View>
                  <View style={styles.courseInfo}>
                    <Text style={styles.courseTitle}>{course.title}</Text>
                    <Text style={styles.courseDescription}>{course.description}</Text>
                    {course.duration && (
                      <View style={styles.courseMeta}>
                        <Ionicons name="time-outline" size={14} color="#718096" />
                        <Text style={styles.courseMetaText}>{course.duration}</Text>
                      </View>
                    )}
                  </View>
                  <Ionicons 
                    name={isPremium ? "play-circle" : "lock-closed"} 
                    size={28} 
                    color={isPremium ? (course.color || '#375B50') : "#cbd5e0"} 
                  />
                </TouchableOpacity>
              ))
            )}

            {/* Thinkific Note */}
            <View style={styles.noteCard}>
              <Ionicons name="information-circle" size={20} color="#3b82f6" />
              <Text style={styles.noteText}>
                Courses are hosted on Thinkific. You'll create a free account there to access your content.
              </Text>
            </View>
          </View>
        )}

        {/* Downloads Tab */}
        {activeTab === 'downloads' && (
          <View style={styles.contentSection}>
            <Text style={styles.sectionTitle}>Digital Downloads</Text>
            <Text style={styles.sectionDescription}>
              Guides, workbooks, and audio sessions
            </Text>

            {downloads.length === 0 ? (
              <View style={styles.emptyState}>
                <Ionicons name="download-outline" size={48} color="#cbd5e0" />
                <Text style={styles.emptyStateText}>No downloads available yet</Text>
                <Text style={styles.emptyStateSubtext}>Check back soon for new content!</Text>
              </View>
            ) : (
              <View style={styles.downloadsGrid}>
                {downloads.map((download) => (
                  <TouchableOpacity
                    key={download.id}
                    style={[styles.downloadCard, !isPremium && styles.cardLocked]}
                    onPress={() => openThinkificContent(download.url, download.title)}
                    activeOpacity={0.7}
                  >
                    <View style={styles.downloadIcon}>
                      <Ionicons name={(download.icon || 'document') as any} size={32} color={download.color || '#375B50'} />
                    </View>
                    <Text style={styles.downloadTitle}>{download.title}</Text>
                    <Text style={styles.downloadDescription}>{download.description}</Text>
                    {!isPremium && (
                      <View style={styles.lockBadge}>
                        <Ionicons name="lock-closed" size={12} color="#ffffff" />
                      </View>
                    )}
                  </TouchableOpacity>
                ))}
              </View>
            )}
          </View>
        )}

        {/* Book Section - Always Visible */}
        <View style={styles.bookSection}>
          <Text style={styles.sectionTitle}>📚 The Equestrian Mind Book</Text>
          <Text style={styles.sectionDescription}>
            Available separately on Amazon
          </Text>

          <TouchableOpacity
            style={styles.bookCard}
            onPress={openAmazonBook}
            activeOpacity={0.8}
          >
            <View style={styles.bookContent}>
              <View style={styles.bookIcon}>
                <Ionicons name="book" size={40} color="#ff9900" />
              </View>
              <View style={styles.bookInfo}>
                <Text style={styles.bookTitle}>The Equestrian Mind</Text>
                <Text style={styles.bookSubtitle}>
                  Mental performance strategies for riders who want to ride like a champion
                </Text>
                <View style={styles.bookPriceRow}>
                  <View style={styles.priceTag}>
                    <Text style={styles.priceText}>$25</Text>
                  </View>
                  <Text style={styles.amazonText}>on Amazon</Text>
                </View>
              </View>
            </View>
            <View style={styles.bookAction}>
              <Text style={styles.bookActionText}>View on Amazon</Text>
              <Ionicons name="open-outline" size={18} color="#ff9900" />
            </View>
          </TouchableOpacity>
        </View>

        {/* Help Section */}
        <View style={styles.helpSection}>
          <Text style={styles.helpTitle}>Need Help?</Text>
          <Text style={styles.helpText}>
            If you have trouble accessing your courses after subscribing, make sure to use the same email address when creating your Thinkific account.
          </Text>
          <TouchableOpacity 
            style={styles.helpButton}
            onPress={() => Linking.openURL('mailto:theequestrianmind75@gmail.com?subject=Premium Content Help')}
          >
            <Ionicons name="mail" size={18} color="#375B50" />
            <Text style={styles.helpButtonText}>Contact Support</Text>
          </TouchableOpacity>
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
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#718096',
  },
  scrollView: {
    flex: 1,
  },
  statusBanner: {
    margin: 16,
    marginBottom: 0,
    padding: 16,
    borderRadius: 12,
  },
  statusBannerPremium: {
    backgroundColor: '#375B50',
  },
  statusBannerStandard: {
    backgroundColor: '#64748b',
  },
  statusContent: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  statusTextContainer: {
    flex: 1,
  },
  statusTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#ffffff',
    marginBottom: 2,
  },
  statusSubtitle: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.8)',
  },
  upgradeBannerButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    marginTop: 12,
    alignSelf: 'flex-start',
    gap: 6,
  },
  upgradeBannerButtonText: {
    color: '#375B50',
    fontSize: 14,
    fontWeight: '700',
  },
  tabContainer: {
    flexDirection: 'row',
    margin: 16,
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 4,
  },
  tab: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    gap: 8,
    borderRadius: 10,
  },
  tabActive: {
    backgroundColor: '#f0fdf4',
  },
  tabText: {
    fontSize: 15,
    fontWeight: '600',
    color: '#718096',
  },
  tabTextActive: {
    color: '#375B50',
  },
  contentSection: {
    paddingHorizontal: 16,
    paddingBottom: 24,
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 4,
  },
  sectionDescription: {
    fontSize: 14,
    color: '#718096',
    marginBottom: 16,
  },
  courseCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    gap: 14,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.06,
    shadowRadius: 4,
    elevation: 2,
  },
  cardLocked: {
    opacity: 0.65,
  },
  courseIcon: {
    width: 56,
    height: 56,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  courseInfo: {
    flex: 1,
  },
  courseTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 4,
  },
  courseDescription: {
    fontSize: 13,
    color: '#718096',
    lineHeight: 18,
    marginBottom: 6,
  },
  courseMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  courseMetaText: {
    fontSize: 12,
    color: '#718096',
  },
  noteCard: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    backgroundColor: '#eff6ff',
    padding: 14,
    borderRadius: 10,
    marginTop: 8,
    gap: 10,
  },
  noteText: {
    flex: 1,
    fontSize: 13,
    color: '#3b82f6',
    lineHeight: 18,
  },
  downloadsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  downloadCard: {
    width: '48%',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    position: 'relative',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.06,
    shadowRadius: 4,
    elevation: 2,
  },
  downloadIcon: {
    width: 60,
    height: 60,
    backgroundColor: '#f0fdf4',
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  downloadTitle: {
    fontSize: 14,
    fontWeight: '700',
    color: '#000000',
    textAlign: 'center',
    marginBottom: 6,
  },
  downloadDescription: {
    fontSize: 12,
    color: '#718096',
    textAlign: 'center',
    lineHeight: 16,
  },
  lockBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
    backgroundColor: '#94a3b8',
    width: 24,
    height: 24,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  emptyState: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
    backgroundColor: '#ffffff',
    borderRadius: 12,
  },
  emptyStateText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#64748b',
    marginTop: 16,
  },
  emptyStateSubtext: {
    fontSize: 14,
    color: '#94a3b8',
    marginTop: 4,
  },
  bookSection: {
    paddingHorizontal: 16,
    paddingBottom: 24,
  },
  bookCard: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    borderWidth: 2,
    borderColor: '#ff9900',
    overflow: 'hidden',
  },
  bookContent: {
    flexDirection: 'row',
    padding: 16,
    gap: 14,
  },
  bookIcon: {
    width: 70,
    height: 90,
    backgroundColor: '#fff7ed',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  bookInfo: {
    flex: 1,
  },
  bookTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 4,
  },
  bookSubtitle: {
    fontSize: 13,
    color: '#718096',
    lineHeight: 18,
    marginBottom: 10,
  },
  bookPriceRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  priceTag: {
    backgroundColor: '#ff9900',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 6,
  },
  priceText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
  amazonText: {
    fontSize: 13,
    color: '#718096',
  },
  bookAction: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#fff7ed',
    paddingVertical: 12,
    gap: 8,
  },
  bookActionText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#ff9900',
  },
  helpSection: {
    backgroundColor: '#ffffff',
    margin: 16,
    padding: 20,
    borderRadius: 12,
    marginBottom: 32,
  },
  helpTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#000000',
    marginBottom: 8,
  },
  helpText: {
    fontSize: 14,
    color: '#718096',
    lineHeight: 20,
    marginBottom: 16,
  },
  helpButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#f0fdf4',
    paddingVertical: 12,
    borderRadius: 8,
    gap: 8,
  },
  helpButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#375B50',
  },
});

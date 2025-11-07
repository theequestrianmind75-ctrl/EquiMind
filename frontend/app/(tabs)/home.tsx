import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { useAuthStore } from '../../lib/store';
import { Ionicons } from '@expo/vector-icons';

export default function Home() {
  const router = useRouter();
  const { user, logout } = useAuthStore();

  const handleLogout = async () => {
    await logout();
    router.replace('/(auth)/login');
  };

  const quickActions = [
    {
      id: 'pre-ride',
      title: 'Pre-Ride Prep',
      description: 'Set your intention and mental state',
      icon: 'checkmark-circle',
      color: '#10b981',
      route: '/pre-ride',
    },
    {
      id: 'during-ride',
      title: 'During Ride',
      description: 'Real-time coaching with voice trigger',
      icon: 'mic',
      color: '#3b82f6',
      route: '/during-ride',
    },
    {
      id: 'post-ride',
      title: 'Post-Ride Review',
      description: 'Reflect and analyze your session',
      icon: 'analytics',
      color: '#8b5cf6',
      route: '/post-ride',
    },
  ];

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ScrollView style={styles.scrollView}>
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Welcome back,</Text>
            <Text style={styles.name}>{user?.name}</Text>
          </View>
          <TouchableOpacity onPress={handleLogout} style={styles.logoutButton}>
            <Ionicons name="log-out-outline" size={24} color="#ef4444" />
          </TouchableOpacity>
        </View>

        <View style={styles.heroCard}>
          <Image
            source={require('../../assets/images/horse-head-logo.png')}
            style={styles.heroLogo}
          />
          <Text style={styles.heroTitle}>Strengthen Your Mindset</Text>
          <Text style={styles.heroSubtitle}>Excel in the Saddle</Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Quick Actions</Text>
          {quickActions.map((action) => (
            <TouchableOpacity
              key={action.id}
              style={styles.actionCard}
              onPress={() => router.push(action.route as any)}
            >
              <View style={[styles.actionIcon, { backgroundColor: action.color + '20' }]}>
                <Ionicons name={action.icon as any} size={28} color={action.color} />
              </View>
              <View style={styles.actionContent}>
                <Text style={styles.actionTitle}>{action.title}</Text>
                <Text style={styles.actionDescription}>{action.description}</Text>
              </View>
              <Ionicons name="chevron-forward" size={24} color="#64748b" />
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Features</Text>
          <View style={styles.featureGrid}>
            <View style={styles.featureCard}>
              <Ionicons name="library" size={32} color="#3b82f6" />
              <Text style={styles.featureTitle}>Mental Strategies</Text>
              <Text style={styles.featureDescription}>Evidence-based techniques</Text>
            </View>
            <View style={styles.featureCard}>
              <Ionicons name="headset" size={32} color="#10b981" />
              <Text style={styles.featureTitle}>Voice Coaching</Text>
              <Text style={styles.featureDescription}>Say "advice" for tips</Text>
            </View>
            <View style={styles.featureCard}>
              <Ionicons name="trending-up" size={32} color="#8b5cf6" />
              <Text style={styles.featureTitle}>Track Progress</Text>
              <Text style={styles.featureDescription}>Monitor your growth</Text>
            </View>
            <View style={styles.featureCard}>
              <Ionicons name="flash" size={32} color="#f59e0b" />
              <Text style={styles.featureTitle}>Real-Time TTS</Text>
              <Text style={styles.featureDescription}>Audio guidance</Text>
            </View>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
  },
  scrollView: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 24,
  },
  greeting: {
    fontSize: 16,
    color: '#94a3b8',
  },
  name: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginTop: 4,
  },
  logoutButton: {
    padding: 8,
  },
  heroCard: {
    backgroundColor: '#1e293b',
    margin: 24,
    marginTop: 0,
    padding: 32,
    borderRadius: 16,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#334155',
  },
  heroTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginTop: 16,
    textAlign: 'center',
  },
  heroSubtitle: {
    fontSize: 16,
    color: '#94a3b8',
    marginTop: 8,
  },
  section: {
    padding: 24,
    paddingTop: 0,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginBottom: 16,
  },
  actionCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#1e293b',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  actionIcon: {
    width: 56,
    height: 56,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 16,
  },
  actionContent: {
    flex: 1,
  },
  actionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#f1f5f9',
    marginBottom: 4,
  },
  actionDescription: {
    fontSize: 14,
    color: '#94a3b8',
  },
  featureGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginHorizontal: -6,
  },
  featureCard: {
    width: '48%',
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    margin: '1%',
    borderWidth: 1,
    borderColor: '#334155',
    alignItems: 'center',
  },
  featureTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#f1f5f9',
    marginTop: 12,
    textAlign: 'center',
  },
  featureDescription: {
    fontSize: 12,
    color: '#94a3b8',
    marginTop: 4,
    textAlign: 'center',
  },
});

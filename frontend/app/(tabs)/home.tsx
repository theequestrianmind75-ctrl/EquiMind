import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
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
      color: '#375B50',
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
          <Text style={styles.heroTitle}>How It Works</Text>
          <Text style={styles.heroDescription}>
            <Text style={styles.bold}>Pre-Ride:</Text> Set your mental state and choose strategies for you and your horse
            {"\n\n"}
            <Text style={styles.bold}>During Ride:</Text> Say "advice" to trigger voice coaching with
            real-time guidance for both you and your horse
            {"\n\n"}
            <Text style={styles.bold}>Post-Ride:</Text> Reflect on your session and track progress for you and your horse
          </Text>
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
              <Ionicons name="chevron-forward" size={24} color="#000000" />
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Horse-Rider Connection</Text>
          <TouchableOpacity 
            style={styles.connectionCard}
            onPress={() => router.push('/horse-rider-connection' as any)}
          >
            <View style={styles.connectionHeader}>
              <Ionicons name="horse" size={40} color="#000000" />
              <Text style={styles.connectionTitle}>Build Your Partnership Profile</Text>
            </View>
            <Text style={styles.connectionText}>
              Understanding your riding background and your horse's personality helps create a stronger bond and improves your communication.
            </Text>
            <View style={styles.connectionButton}>
              <Text style={styles.connectionButtonText}>Complete Profile</Text>
              <Ionicons name="arrow-forward" size={20} color="#ffffff" />
            </View>
          </TouchableOpacity>
          <Text style={styles.connectionDescription}>
            Combining clinical expertise with deep equestrian knowledge to deliver results that transform both rider performance and horse-rider relationships.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
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
    color: '#000000',
  },
  name: {
    fontSize: 28,
    fontWeight: 'bold',
    fontFamily: 'PlayfairDisplay_700Bold',
    color: '#1e293b',
    marginTop: 4,
  },
  logoutButton: {
    padding: 8,
  },
  heroCard: {
    backgroundColor: '#ffffff',
    margin: 24,
    marginTop: 0,
    padding: 32,
    borderRadius: 16,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#375B50',
  },
  heroLogo: {
    width: 60,
    height: 60,
    resizeMode: 'contain',
    marginBottom: 16,
  },
  heroTitle: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 16,
    textAlign: 'center',
  },
  heroDescription: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
    textAlign: 'left',
  },
  bold: {
    fontWeight: '600',
    color: '#1e293b',
  },
  section: {
    padding: 24,
    paddingTop: 0,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    fontFamily: 'PlayfairDisplay_700Bold',
    color: '#375B50',
    marginBottom: 16,
  },
  actionCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#375B50',
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
    color: '#1e293b',
    marginBottom: 4,
  },
  actionDescription: {
    fontSize: 14,
    color: '#000000',
  },
  connectionCard: {
    backgroundColor: '#ffffff',
    padding: 24,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  connectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  connectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#000000',
    marginLeft: 16,
    flex: 1,
  },
  connectionText: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
    marginBottom: 16,
  },
  connectionButton: {
    flexDirection: 'row',
    backgroundColor: '#14b8a6',
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    alignSelf: 'flex-start',
  },
  connectionButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginRight: 8,
  },
  connectionDescription: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
    textAlign: 'center',
  },
});

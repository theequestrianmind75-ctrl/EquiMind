import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Share,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

interface Session {
  id: string;
  session_type: string;
  ride_type: string;
  anxiety_level: number | null;
  confidence_level: number | null;
  horse_energy_level: number | null;
  horse_focus_level: number | null;
  horse_responsiveness: number | null;
  horse_notes: string | null;
  notes: string | null;
  strategies_used: string[];
  completed: boolean;
  created_at: string;
  completed_at: string | null;
}

export default function RideSummary() {
  const router = useRouter();
  const { sessionId } = useLocalSearchParams();
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (sessionId) {
      fetchSession();
    }
  }, [sessionId]);

  const fetchSession = async () => {
    try {
      const response = await api.get(`/sessions/${sessionId}`);
      setSession(response.data);
    } catch (error) {
      console.error('Error fetching session:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleShare = async () => {
    if (!session) return;

    const summary = generateSummaryText();
    try {
      await Share.share({
        message: summary,
        title: 'My Ride Summary',
      });
    } catch (error) {
      console.error('Error sharing:', error);
    }
  };

  const generateSummaryText = () => {
    if (!session) return '';

    const date = new Date(session.created_at).toLocaleDateString();
    const rideType = session.ride_type.charAt(0).toUpperCase() + session.ride_type.slice(1);

    return `
🐴 EquiMind Ride Summary
Date: ${date}
Ride Type: ${rideType}

RIDER METRICS:
• Pre-Ride Anxiety: ${session.anxiety_level || 'N/A'}/10
• Pre-Ride Confidence: ${session.confidence_level || 'N/A'}/10

HORSE ASSESSMENT:
• Energy Level: ${session.horse_energy_level || 'N/A'}/10
• Focus Level: ${session.horse_focus_level || 'N/A'}/10
• Responsiveness: ${session.horse_responsiveness || 'N/A'}/10
${session.horse_notes ? `• Notes: ${session.horse_notes}` : ''}

${session.strategies_used && session.strategies_used.length > 0 ? `TOOLS USED:\n${session.strategies_used.map(s => `• ${s}`).join('\n')}` : ''}

${session.notes ? `REFLECTION:\n${session.notes}` : ''}

Status: ${session.completed ? 'Completed' : 'In Progress'}
    `.trim();
  };

  const getEnergyLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Low';
    if (level <= 7) return 'Moderate';
    return 'High';
  };

  const getFocusLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Distracted';
    if (level <= 7) return 'Moderate';
    return 'Focused';
  };

  const getResponsivenessLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Low';
    if (level <= 7) return 'Moderate';
    return 'High';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
          <Text style={styles.loadingText}>Loading summary...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!session) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
            <Ionicons name="arrow-back" size={24} color="#1e293b" />
          </TouchableOpacity>
          <Text style={styles.title}>Ride Summary</Text>
          <View style={styles.placeholder} />
        </View>
        <View style={styles.errorContainer}>
          <Ionicons name="alert-circle" size={64} color="#ef4444" />
          <Text style={styles.errorText}>Session not found</Text>
        </View>
      </SafeAreaView>
    );
  }

  const rideTypeLabel = session.ride_type.charAt(0).toUpperCase() + session.ride_type.slice(1);
  const date = new Date(session.created_at).toLocaleDateString();

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1e293b" />
        </TouchableOpacity>
        <Text style={styles.title}>Ride Summary</Text>
        <TouchableOpacity onPress={handleShare} style={styles.shareButton}>
          <Ionicons name="share-outline" size={24} color="#375B50" />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scrollView}>
        <View style={styles.summaryCard}>
          <View style={styles.summaryHeader}>
            <Ionicons name="horse" size={32} color="#375B50" />
            <View style={styles.summaryHeaderText}>
              <Text style={styles.summaryTitle}>{rideTypeLabel} Ride</Text>
              <Text style={styles.summaryDate}>{date}</Text>
            </View>
            <View style={[styles.statusBadge, session.completed && styles.statusBadgeComplete]}>
              <Text style={styles.statusText}>{session.completed ? 'Complete' : 'In Progress'}</Text>
            </View>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Rider Metrics</Text>
          <View style={styles.metricsCard}>
            <View style={styles.metricRow}>
              <Text style={styles.metricLabel}>Pre-Ride Anxiety:</Text>
              <Text style={styles.metricValue}>{session.anxiety_level || 'N/A'}/10</Text>
            </View>
            <View style={styles.metricRow}>
              <Text style={styles.metricLabel}>Pre-Ride Confidence:</Text>
              <Text style={styles.metricValue}>{session.confidence_level || 'N/A'}/10</Text>
            </View>
          </View>
        </View>

        {(session.horse_energy_level || session.horse_focus_level || session.horse_responsiveness) && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Horse Assessment</Text>
            <View style={styles.metricsCard}>
              <View style={styles.metricRow}>
                <Text style={styles.metricLabel}>Energy Level:</Text>
                <Text style={styles.metricValue}>
                  {session.horse_energy_level || 'N/A'}/10 - {getEnergyLabel(session.horse_energy_level)}
                </Text>
              </View>
              <View style={styles.metricRow}>
                <Text style={styles.metricLabel}>Focus Level:</Text>
                <Text style={styles.metricValue}>
                  {session.horse_focus_level || 'N/A'}/10 - {getFocusLabel(session.horse_focus_level)}
                </Text>
              </View>
              <View style={styles.metricRow}>
                <Text style={styles.metricLabel}>Responsiveness:</Text>
                <Text style={styles.metricValue}>
                  {session.horse_responsiveness || 'N/A'}/10 - {getResponsivenessLabel(session.horse_responsiveness)}
                </Text>
              </View>
              {session.horse_notes && (
                <View style={styles.notesSection}>
                  <Text style={styles.notesLabel}>Horse Notes:</Text>
                  <Text style={styles.notesText}>{session.horse_notes}</Text>
                </View>
              )}
            </View>
          </View>
        )}

        {session.strategies_used && session.strategies_used.length > 0 && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Tools Used</Text>
            <View style={styles.toolsCard}>
              {session.strategies_used.map((strategy, index) => (
                <View key={index} style={styles.toolItem}>
                  <Ionicons name="checkmark-circle" size={20} color="#10b981" />
                  <Text style={styles.toolText}>{strategy}</Text>
                </View>
              ))}
            </View>
          </View>
        )}

        {session.notes && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Rider Reflection</Text>
            <View style={styles.reflectionCard}>
              <Text style={styles.reflectionText}>{session.notes}</Text>
            </View>
          </View>
        )}

        <View style={styles.actionButtons}>
          <TouchableOpacity style={styles.shareButtonLarge} onPress={handleShare}>
            <Ionicons name="share-social" size={24} color="#ffffff" />
            <Text style={styles.shareButtonText}>Share Summary</Text>
          </TouchableOpacity>
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
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#000000',
    fontSize: 16,
  },
  errorContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
  },
  errorText: {
    marginTop: 16,
    fontSize: 18,
    color: '#ef4444',
    textAlign: 'center',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    paddingTop: 8,
  },
  backButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: '#000000',
    flex: 1,
    textAlign: 'center',
  },
  shareButton: {
    padding: 8,
  },
  placeholder: {
    width: 40,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  summaryCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  summaryHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  summaryHeaderText: {
    flex: 1,
    marginLeft: 16,
  },
  summaryTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
  },
  summaryDate: {
    fontSize: 14,
    color: '#000000',
    marginTop: 4,
  },
  statusBadge: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: '#f59e0b20',
  },
  statusBadgeComplete: {
    backgroundColor: '#10b98120',
  },
  statusText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#000000',
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 12,
  },
  metricsCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  metricRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#e2e8f0',
  },
  metricLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
  },
  metricValue: {
    fontSize: 14,
    color: '#000000',
    fontWeight: '500',
  },
  notesSection: {
    marginTop: 16,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#e2e8f0',
  },
  notesLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 8,
  },
  notesText: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 20,
  },
  toolsCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  toolItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
  },
  toolText: {
    fontSize: 14,
    color: '#000000',
    marginLeft: 12,
    flex: 1,
  },
  reflectionCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  reflectionText: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
  },
  actionButtons: {
    marginBottom: 32,
  },
  shareButtonLarge: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  shareButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 12,
  },
});

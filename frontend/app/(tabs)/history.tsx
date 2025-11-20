import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  RefreshControl,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../../lib/api';
import { format } from 'date-fns';

interface Session {
  id: string;
  session_type: string;
  ride_type: string;
  anxiety_level: number | null;
  confidence_level: number | null;
  notes: string | null;
  completed: boolean;
  created_at: string;
  completed_at: string | null;
}

export default function History() {
  const router = useRouter();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    fetchSessions();
  }, []);

  const fetchSessions = async () => {
    try {
      const response = await api.get('/sessions?limit=100');
      setSessions(response.data);
    } catch (error) {
      console.error('Error fetching sessions:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const groupSessionsByMonth = () => {
    const grouped: { [key: string]: Session[] } = {};
    
    sessions.forEach((session) => {
      const date = new Date(session.created_at);
      const monthKey = format(date, 'MMMM yyyy'); // e.g., "November 2024"
      
      if (!grouped[monthKey]) {
        grouped[monthKey] = [];
      }
      grouped[monthKey].push(session);
    });
    
    return grouped;
  };

  const onRefresh = () => {
    setRefreshing(true);
    fetchSessions();
  };

  const getSessionIcon = (sessionType: string) => {
    if (sessionType === 'pre-ride') return 'checkmark-circle';
    if (sessionType === 'during-ride') return 'mic';
    if (sessionType === 'post-ride') return 'analytics';
    return 'ellipse';
  };

  const getSessionColor = (sessionType: string) => {
    if (sessionType === 'pre-ride') return '#10b981';
    if (sessionType === 'during-ride') return '#000000';
    if (sessionType === 'post-ride') return '#8b5cf6';
    return '#000000';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#000000" />
          <Text style={styles.loadingText}>Loading sessions...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <Text style={styles.title}>Session History</Text>
        <Text style={styles.subtitle}>{sessions.length} sessions recorded</Text>
      </View>

      {sessions.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Ionicons name="calendar-outline" size={64} color="#000000" />
          <Text style={styles.emptyTitle}>No Sessions Yet</Text>
          <Text style={styles.emptyText}>Start your first ride to see your history here</Text>
        </View>
      ) : (
        <ScrollView
          style={styles.scrollView}
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#000000" />}
        >
          {Object.entries(groupSessionsByMonth()).map(([month, monthSessions]) => (
            <View key={month}>
              <Text style={styles.monthHeader}>{month}</Text>
              {monthSessions.map((session) => (
            <View key={session.id} style={styles.sessionCard}>
              <View style={styles.sessionHeader}>
                <View
                  style={[
                    styles.sessionIcon,
                    { backgroundColor: getSessionColor(session.session_type) + '20' },
                  ]}
                >
                  <Ionicons
                    name={getSessionIcon(session.session_type) as any}
                    size={24}
                    color={getSessionColor(session.session_type)}
                  />
                </View>
                <View style={styles.sessionInfo}>
                  <Text style={styles.sessionType}>
                    {session.session_type.split('-').map((w) => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')}
                  </Text>
                  <Text style={styles.sessionDate}>{format(new Date(session.created_at), 'MMM d, yyyy • h:mm a')}</Text>
                </View>
                {session.completed ? (
                  <View style={styles.completedBadge}>
                    <Ionicons name="checkmark-circle" size={20} color="#10b981" />
                  </View>
                ) : (
                  <View style={styles.inProgressBadge}>
                    <Text style={styles.inProgressText}>In Progress</Text>
                  </View>
                )}
              </View>

              <View style={styles.sessionDetails}>
                <View style={styles.detailRow}>
                  <Ionicons name="trail-sign-outline" size={16} color="#000000" />
                  <Text style={styles.detailText}>
                    {session.ride_type.charAt(0).toUpperCase() + session.ride_type.slice(1)}
                  </Text>
                </View>

                {session.anxiety_level !== null && (
                  <View style={styles.detailRow}>
                    <Ionicons name="pulse-outline" size={16} color="#000000" />
                    <Text style={styles.detailText}>Anxiety: {session.anxiety_level}/10</Text>
                  </View>
                )}

                {session.confidence_level !== null && (
                  <View style={styles.detailRow}>
                    <Ionicons name="shield-checkmark-outline" size={16} color="#000000" />
                    <Text style={styles.detailText}>Confidence: {session.confidence_level}/10</Text>
                  </View>
                )}
              </View>

              {session.notes && (
                <View style={styles.notesContainer}>
                  <Text style={styles.notesLabel}>Notes:</Text>
                  <Text style={styles.notesText}>{session.notes}</Text>
                </View>
              )}

              {session.completed && (
                <TouchableOpacity
                  style={styles.viewSummaryButton}
                  onPress={() => router.push(`/ride-summary?sessionId=${session.id}` as any)}
                >
                  <Ionicons name="document-text" size={20} color="#ffffff" />
                  <Text style={styles.viewSummaryText}>View Summary</Text>
                </TouchableOpacity>
              )}
            </View>
          )))}
            </View>
          ))}
        </ScrollView>
      )}
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
  header: {
    padding: 24,
    paddingBottom: 16,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#1e293b',
  },
  subtitle: {
    fontSize: 14,
    color: '#000000',
    marginTop: 4,
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 48,
  },
  emptyTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 16,
  },
  emptyText: {
    fontSize: 14,
    color: '#000000',
    marginTop: 8,
    textAlign: 'center',
  },
  scrollView: {
    flex: 1,
    paddingHorizontal: 24,
  },
  monthHeader: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 24,
    marginBottom: 12,
    paddingBottom: 8,
    borderBottomWidth: 2,
    borderBottomColor: '#375B50',
  },
  sessionCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  sessionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  sessionIcon: {
    width: 48,
    height: 48,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  sessionInfo: {
    flex: 1,
  },
  sessionType: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
  },
  sessionDate: {
    fontSize: 12,
    color: '#000000',
    marginTop: 2,
  },
  completedBadge: {
    padding: 4,
  },
  inProgressBadge: {
    backgroundColor: '#f59e0b20',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  inProgressText: {
    fontSize: 12,
    color: '#f59e0b',
    fontWeight: '600',
  },
  sessionDetails: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
    marginBottom: 4,
  },
  detailText: {
    marginLeft: 6,
    fontSize: 14,
    color: '#000000',
  },
  notesContainer: {
    marginTop: 12,
    paddingTop: 12,
    borderTopWidth: 1,
    borderTopColor: '#334155',
  },
  notesLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  notesText: {
    fontSize: 14,
    color: '#1e293b',
    lineHeight: 20,
  },
  viewSummaryButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 12,
  },
  viewSummaryText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
});

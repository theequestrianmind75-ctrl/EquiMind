import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  ActivityIndicator,
  RefreshControl,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import api from '../../lib/api';

interface TrendsData {
  has_enough_data: boolean;
  message?: string;
  session_count: number;
  anxiety?: {
    current: number;
    average: number;
    trend: string;
    history: number[];
  };
  confidence?: {
    current: number;
    average: number;
    trend: string;
    history: number[];
  };
  horse?: {
    avg_energy: number;
    avg_focus: number;
  };
  best_session?: {
    id: string;
    ride_type: string;
    anxiety: number;
    confidence: number;
    created_at: string;
  };
  patterns?: Array<{
    type: string;
    message: string;
    severity: string;
  }>;
  ride_type_distribution?: {
    training: number;
    competition: number;
    trail: number;
    lesson: number;
  };
}

export default function Trends() {
  const [trends, setTrends] = useState<TrendsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const loadTrends = async () => {
    try {
      const response = await api.get('/trends');
      setTrends(response.data);
    } catch (error) {
      console.error('Error loading trends:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    loadTrends();
  }, []);

  const onRefresh = () => {
    setRefreshing(true);
    loadTrends();
  };

  const getTrendIcon = (trend: string) => {
    if (trend === 'increasing') return 'trending-up';
    if (trend === 'decreasing') return 'trending-down';
    return 'remove';
  };

  const getTrendColor = (trend: string, metric: 'anxiety' | 'confidence') => {
    if (metric === 'anxiety') {
      if (trend === 'decreasing') return '#10b981'; // Good
      if (trend === 'increasing') return '#ef4444'; // Bad
    } else {
      if (trend === 'increasing') return '#10b981'; // Good
      if (trend === 'decreasing') return '#ef4444'; // Bad
    }
    return '#64748b'; // Neutral
  };

  const getPatternIcon = (severity: string) => {
    if (severity === 'positive') return 'checkmark-circle';
    if (severity === 'moderate') return 'alert-circle';
    return 'information-circle';
  };

  const getPatternColor = (severity: string) => {
    if (severity === 'positive') return '#10b981';
    if (severity === 'moderate') return '#f59e0b';
    return '#3b82f6';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
          <Text style={styles.loadingText}>Analyzing your riding patterns...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!trends || !trends.has_enough_data) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.header}>
          <Text style={styles.title}>Riding Trends</Text>
        </View>
        <View style={styles.emptyContainer}>
          <Ionicons name="bar-chart-outline" size={80} color="#94a3b8" />
          <Text style={styles.emptyTitle}>Not Enough Data</Text>
          <Text style={styles.emptyText}>
            {trends?.message || 'Complete at least 2 sessions to see your riding trends and patterns.'}
          </Text>
          <Text style={styles.emptySubtext}>
            Current sessions: {trends?.session_count || 0}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <Text style={styles.title}>Riding Trends</Text>
        <Text style={styles.subtitle}>Last {trends.session_count} sessions analyzed</Text>
      </View>

      <ScrollView
        style={styles.scrollView}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
      >
        {/* Historical Trend Analysis */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Ionicons name="trending-up" size={24} color="#375B50" />
            <Text style={styles.sectionTitle}>Historical Trends</Text>
          </View>

          {/* Anxiety Trend */}
          {trends.anxiety && (
            <View style={styles.trendCard}>
              <View style={styles.trendHeader}>
                <Text style={styles.trendLabel}>Anxiety Level</Text>
                <View style={[styles.trendBadge, { backgroundColor: getTrendColor(trends.anxiety.trend, 'anxiety') + '20' }]}>
                  <Text style={[styles.trendText, { color: getTrendColor(trends.anxiety.trend, 'anxiety') }]}>
                    {trends.anxiety.trend}
                  </Text>
                </View>
              </View>
              <View style={styles.trendStats}>
                <View style={styles.stat}>
                  <Text style={styles.statValue}>{trends.anxiety.current.toFixed(1)}</Text>
                  <Text style={styles.statLabel}>Current</Text>
                </View>
                <View style={styles.stat}>
                  <Text style={styles.statValue}>{trends.anxiety.average.toFixed(1)}</Text>
                  <Text style={styles.statLabel}>Average</Text>
                </View>
              </View>
              <View style={styles.historyChart}>
                {trends.anxiety.history.map((level, index) => (
                  <View key={index} style={styles.historyBar}>
                    <View
                      style={[
                        styles.historyBarFill,
                        {
                          height: `${(level / 10) * 100}%`,
                          backgroundColor: level >= 7 ? '#ef4444' : level <= 3 ? '#10b981' : '#f59e0b',
                        },
                      ]}
                    />
                  </View>
                ))}
              </View>
            </View>
          )}

          {/* Confidence Trend */}
          {trends.confidence && (
            <View style={styles.trendCard}>
              <View style={styles.trendHeader}>
                <Text style={styles.trendLabel}>Confidence Level</Text>
                <View style={[styles.trendBadge, { backgroundColor: getTrendColor(trends.confidence.trend, 'confidence') + '20' }]}>
                  <Text style={[styles.trendText, { color: getTrendColor(trends.confidence.trend, 'confidence') }]}>
                    {trends.confidence.trend}
                  </Text>
                </View>
              </View>
              <View style={styles.trendStats}>
                <View style={styles.stat}>
                  <Text style={styles.statValue}>{trends.confidence.current.toFixed(1)}</Text>
                  <Text style={styles.statLabel}>Current</Text>
                </View>
                <View style={styles.stat}>
                  <Text style={styles.statValue}>{trends.confidence.average.toFixed(1)}</Text>
                  <Text style={styles.statLabel}>Average</Text>
                </View>
              </View>
              <View style={styles.historyChart}>
                {trends.confidence.history.map((level, index) => (
                  <View key={index} style={styles.historyBar}>
                    <View
                      style={[
                        styles.historyBarFill,
                        {
                          height: `${(level / 10) * 100}%`,
                          backgroundColor: level >= 7 ? '#10b981' : level <= 3 ? '#ef4444' : '#f59e0b',
                        },
                      ]}
                    />
                  </View>
                ))}
              </View>
            </View>
          )}

          {/* Horse Metrics */}
          {trends.horse && (
            <View style={styles.trendCard}>
              <View style={styles.trendHeader}>
                <Text style={styles.trendLabel}>Horse Averages</Text>
              </View>
              <View style={styles.horseMetrics}>
                <View style={styles.horseMetric}>
                  <Text style={styles.horseMetricValue}>{trends.horse.avg_energy?.toFixed(1)}/10</Text>
                  <Text style={styles.horseMetricLabel}>Energy</Text>
                </View>
                <View style={styles.horseMetric}>
                  <Text style={styles.horseMetricValue}>{trends.horse.avg_focus?.toFixed(1)}/10</Text>
                  <Text style={styles.horseMetricLabel}>Focus</Text>
                </View>
              </View>
            </View>
          )}
        </View>

        {/* Pattern Detection */}
        {trends.patterns && trends.patterns.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>Patterns Detected</Text>
            </View>
            {trends.patterns.map((pattern, index) => (
              <View key={index} style={styles.patternCard}>
                <View style={styles.patternIcon}>
                  <Ionicons
                    name={getPatternIcon(pattern.severity)}
                    size={24}
                    color={getPatternColor(pattern.severity)}
                  />
                </View>
                <Text style={styles.patternText}>{pattern.message}</Text>
              </View>
            ))}
          </View>
        )}

        {/* Best Session */}
        {trends.best_session && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>Best Session</Text>
            </View>
            <View style={styles.bestSessionCard}>
              <View style={styles.bestSessionHeader}>
                <View style={styles.bestSessionIcon}>
                  <Ionicons name="star" size={32} color="#f59e0b" />
                </View>
                <Text style={styles.bestSessionType}>{trends.best_session.ride_type}</Text>
              </View>
              <View style={styles.bestSessionStats}>
                <View style={styles.bestStat}>
                  <Text style={styles.bestStatLabel}>Anxiety</Text>
                  <Text style={[styles.bestStatValue, { color: '#10b981' }]}>
                    {trends.best_session.anxiety}/10
                  </Text>
                </View>
                <View style={styles.bestStatDivider} />
                <View style={styles.bestStat}>
                  <Text style={styles.bestStatLabel}>Confidence</Text>
                  <Text style={[styles.bestStatValue, { color: '#10b981' }]}>
                    {trends.best_session.confidence}/10
                  </Text>
                </View>
              </View>
            </View>
          </View>
        )}

        {/* Ride Type Distribution */}
        {trends.ride_type_distribution && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <Ionicons name="pie-chart" size={24} color="#375B50" />
              <Text style={styles.sectionTitle}>Session Distribution</Text>
            </View>
            <View style={styles.distributionCard}>
              {Object.entries(trends.ride_type_distribution).map(([type, count]) => (
                count > 0 && (
                  <View key={type} style={styles.distributionRow}>
                    <Text style={styles.distributionType}>{type}</Text>
                    <Text style={styles.distributionCount}>{count} sessions</Text>
                  </View>
                )
              ))}
            </View>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
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
  scrollView: {
    flex: 1,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  loadingText: {
    fontSize: 16,
    color: '#000000',
    marginTop: 16,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  emptyTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 24,
    marginBottom: 12,
  },
  emptyText: {
    fontSize: 16,
    color: '#000000',
    textAlign: 'center',
    lineHeight: 24,
  },
  emptySubtext: {
    fontSize: 14,
    color: '#64748b',
    marginTop: 8,
  },
  section: {
    paddingHorizontal: 24,
    marginBottom: 32,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginLeft: 8,
  },
  trendCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#375B50',
    height: 200,
  },
  trendHeader: {
    flexDirection: 'column',
    alignItems: 'flex-start',
    marginBottom: 12,
  },
  trendLabel: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
    textAlign: 'left',
    marginBottom: 6,
  },
  trendBadge: {
    alignSelf: 'center',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
    marginTop: 4,
  },
  trendText: {
    fontSize: 18,
    fontWeight: 'bold',
    textTransform: 'capitalize',
    textAlign: 'center',
  },
  trendStats: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 20,
  },
  stat: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#1e293b',
  },
  statLabel: {
    fontSize: 12,
    color: '#64748b',
    marginTop: 4,
  },
  historyChart: {
    flexDirection: 'row',
    height: 60,
    alignItems: 'flex-end',
    justifyContent: 'space-between',
  },
  historyBar: {
    flex: 1,
    backgroundColor: '#f1f5f9',
    marginHorizontal: 2,
    borderRadius: 4,
  },
  historyBarFill: {
    width: '100%',
    borderRadius: 4,
    alignSelf: 'flex-end',
  },
  horseMetrics: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginTop: 8,
  },
  horseMetric: {
    alignItems: 'center',
    flex: 1,
  },
  horseMetricValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e293b',
  },
  horseMetricLabel: {
    fontSize: 12,
    color: '#64748b',
    marginTop: 8,
  },
  patternCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  patternIcon: {
    marginRight: 12,
  },
  patternText: {
    flex: 1,
    fontSize: 14,
    color: '#1e293b',
    lineHeight: 20,
  },
  bestSessionCard: {
    backgroundColor: '#ffffff',
    padding: 24,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#f59e0b',
  },
  bestSessionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  bestSessionIcon: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: '#fef3c7',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 16,
  },
  bestSessionType: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    textTransform: 'capitalize',
  },
  bestSessionStats: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  bestStat: {
    flex: 1,
    alignItems: 'center',
  },
  bestStatDivider: {
    width: 1,
    height: 40,
    backgroundColor: '#e2e8f0',
    marginHorizontal: 20,
  },
  bestStatLabel: {
    fontSize: 12,
    color: '#64748b',
    marginBottom: 8,
  },
  bestStatValue: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  distributionCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  distributionRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f5f9',
  },
  distributionType: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
    textTransform: 'capitalize',
  },
  distributionCount: {
    fontSize: 14,
    color: '#64748b',
  },
});

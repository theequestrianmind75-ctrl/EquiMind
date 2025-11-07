import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  TextInput,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../../lib/api';

interface Strategy {
  id: string;
  name: string;
  category: string;
  duration_minutes: number;
  effectiveness_rating: number;
  anxiety_level: number[];
  confidence_level: number[];
}

export default function Strategies() {
  const router = useRouter();
  const [strategies, setStrategies] = useState<Strategy[]>([]);
  const [filteredStrategies, setFilteredStrategies] = useState<Strategy[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    fetchStrategies();
  }, []);

  useEffect(() => {
    if (searchQuery) {
      const filtered = strategies.filter(
        (s) =>
          s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
          s.category.toLowerCase().includes(searchQuery.toLowerCase())
      );
      setFilteredStrategies(filtered);
    } else {
      setFilteredStrategies(strategies);
    }
  }, [searchQuery, strategies]);

  const fetchStrategies = async () => {
    try {
      const response = await api.get('/mental-strategies');
      setStrategies(response.data);
      setFilteredStrategies(response.data);
    } catch (error) {
      console.error('Error fetching strategies:', error);
    } finally {
      setLoading(false);
    }
  };

  const getCategoryColor = (category: string) => {
    if (category.includes('Mindfulness')) return '#10b981';
    if (category.includes('Breathing')) return '#3b82f6';
    if (category.includes('Somatic')) return '#8b5cf6';
    if (category.includes('Activation')) return '#f59e0b';
    if (category.includes('Cognitive')) return '#06b6d4';
    return '#6366f1';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#3b82f6" />
          <Text style={styles.loadingText}>Loading strategies...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <Text style={styles.title}>Mental Strategies</Text>
        <Text style={styles.subtitle}>{filteredStrategies.length} strategies available</Text>
      </View>

      <View style={styles.searchContainer}>
        <Ionicons name="search" size={20} color="#64748b" style={styles.searchIcon} />
        <TextInput
          style={styles.searchInput}
          placeholder="Search strategies..."
          placeholderTextColor="#64748b"
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
        {searchQuery ? (
          <TouchableOpacity onPress={() => setSearchQuery('')}>
            <Ionicons name="close-circle" size={20} color="#64748b" />
          </TouchableOpacity>
        ) : null}
      </View>

      <ScrollView style={styles.scrollView}>
        {filteredStrategies.map((strategy) => (
          <TouchableOpacity
            key={strategy.id}
            style={styles.strategyCard}
            onPress={() => router.push(`/strategy-detail/${strategy.id}` as any)}
          >
            <View style={styles.strategyHeader}>
              <View
                style={[
                  styles.categoryBadge,
                  { backgroundColor: getCategoryColor(strategy.category) + '20' },
                ]}
              >
                <Text style={[styles.categoryText, { color: getCategoryColor(strategy.category) }]}>
                  {strategy.category.split(',')[0].trim()}
                </Text>
              </View>
              <View style={styles.rating}>
                <Ionicons name="star" size={16} color="#f59e0b" />
                <Text style={styles.ratingText}>{strategy.effectiveness_rating.toFixed(1)}</Text>
              </View>
            </View>

            <Text style={styles.strategyName}>{strategy.name}</Text>

            <View style={styles.strategyMeta}>
              <View style={styles.metaItem}>
                <Ionicons name="time-outline" size={16} color="#64748b" />
                <Text style={styles.metaText}>{strategy.duration_minutes} min</Text>
              </View>
              <View style={styles.metaItem}>
                <Ionicons name="pulse-outline" size={16} color="#64748b" />
                <Text style={styles.metaText}>
                  Anxiety {Math.min(...strategy.anxiety_level)}-{Math.max(...strategy.anxiety_level)}
                </Text>
              </View>
            </View>

            <TouchableOpacity style={styles.viewButton}>
              <Text style={styles.viewButtonText}>View Details</Text>
              <Ionicons name="arrow-forward" size={16} color="#3b82f6" />
            </TouchableOpacity>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
  },
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#94a3b8',
    fontSize: 16,
  },
  header: {
    padding: 24,
    paddingBottom: 16,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#f1f5f9',
  },
  subtitle: {
    fontSize: 14,
    color: '#94a3b8',
    marginTop: 4,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#1e293b',
    marginHorizontal: 24,
    marginBottom: 16,
    paddingHorizontal: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  searchIcon: {
    marginRight: 12,
  },
  searchInput: {
    flex: 1,
    height: 48,
    color: '#f1f5f9',
    fontSize: 16,
  },
  scrollView: {
    flex: 1,
    paddingHorizontal: 24,
  },
  strategyCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#334155',
  },
  strategyHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  categoryBadge: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
  },
  categoryText: {
    fontSize: 12,
    fontWeight: '600',
  },
  rating: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  ratingText: {
    marginLeft: 4,
    color: '#f1f5f9',
    fontSize: 14,
    fontWeight: '600',
  },
  strategyName: {
    fontSize: 18,
    fontWeight: '600',
    color: '#f1f5f9',
    marginBottom: 12,
  },
  strategyMeta: {
    flexDirection: 'row',
    marginBottom: 12,
  },
  metaItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
  },
  metaText: {
    marginLeft: 4,
    color: '#94a3b8',
    fontSize: 14,
  },
  viewButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 8,
  },
  viewButtonText: {
    color: '#3b82f6',
    fontSize: 14,
    fontWeight: '600',
    marginRight: 4,
  },
});

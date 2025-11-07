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

const CATEGORIES = [
  {
    id: 'mindfulness',
    title: 'Mindfulness and Flow',
    description: 'Stay present and connected with your horse',
    icon: 'leaf',
    color: '#10b981',
    keywords: ['mindfulness', 'flow'],
  },
  {
    id: 'breathing',
    title: 'Breathing',
    description: 'Regulate your nervous system through breath',
    icon: 'fitness',
    color: '#3b82f6',
    keywords: ['breathing'],
  },
  {
    id: 'emotional',
    title: 'Emotional Regulation',
    description: 'Manage emotions and maintain composure',
    icon: 'heart',
    color: '#f59e0b',
    keywords: ['activation', 'emotional', 'regulation'],
  },
  {
    id: 'grounding',
    title: 'Grounding',
    description: 'Connect to the present moment and your body',
    icon: 'footsteps',
    color: '#06b6d4',
    keywords: ['grounding'],
  },
  {
    id: 'somatic',
    title: 'Somatic Tools',
    description: 'Body-based techniques for mental clarity',
    icon: 'body',
    color: '#8b5cf6',
    keywords: ['somatic'],
  },
];

export default function Strategies() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <Text style={styles.title}>Rider Tools</Text>
        <Text style={styles.subtitle}>Choose a category to explore techniques</Text>
      </View>

      <ScrollView style={styles.scrollView}>
        {CATEGORIES.map((category) => (
          <TouchableOpacity
            key={category.id}
            style={styles.categoryCard}
            onPress={() => router.push(`/category/${category.id}` as any)}
          >
            <View style={[styles.iconCircle, { backgroundColor: category.color + '20' }]}>
              <Ionicons name={category.icon as any} size={32} color={category.color} />
            </View>
            <View style={styles.categoryContent}>
              <Text style={styles.categoryTitle}>{category.title}</Text>
              <Text style={styles.categoryDescription}>{category.description}</Text>
            </View>
            <Ionicons name="chevron-forward" size={24} color="#64748b" />
          </TouchableOpacity>
        ))}

        <View style={styles.infoCard}>
          <Ionicons name="information-circle" size={24} color="#3b82f6" />
          <Text style={styles.infoText}>
            These tools are personalized based on your pre-ride anxiety and confidence levels.
          </Text>
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

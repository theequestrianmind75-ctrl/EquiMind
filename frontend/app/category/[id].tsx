import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import api from '../../lib/api';

interface Strategy {
  id: string;
  name: string;
  category: string;
  description: string | null;
  duration_minutes: number;
  instructions: string;
  anxiety_level: number[];
  confidence_level: number[];
  effectiveness_rating: number;
}

const CATEGORIES: any = {
  mindfulness: {
    title: 'Mindfulness and Flow',
    color: '#10b981',
    keywords: ['mindfulness', 'flow'],
    excludeKeywords: ['tapping', 'eft'],
  },
  breathing: {
    title: 'Breathing',
    color: '#375B50',
    keywords: ['breathing'],
    excludeKeywords: ['tapping', 'eft'],
  },
  emotional: {
    title: 'Emotional Regulation',
    color: '#f59e0b',
    keywords: ['activation', 'emotional', 'regulation'],
    excludeKeywords: ['tapping', 'eft'],
  },
  grounding: {
    title: 'Grounding',
    color: '#06b6d4',
    keywords: ['grounding'],
    excludeKeywords: ['tapping', 'eft'],
  },
  somatic: {
    title: 'Somatic Tools',
    color: '#8b5cf6',
    keywords: ['somatic'],
    excludeKeywords: ['tapping', 'eft'],
  },
  tapping: {
    title: 'Tapping',
    color: '#ec4899',
    keywords: ['tapping', 'eft'],
    description: 'EFT (Emotional Freedom Technique) or "tapping" uses gentle tapping on specific acupressure points to reduce stress and anxiety. This technique helps calm your nervous system before riding, during challenging moments, or after a difficult session.',
  },
  'horse-rider': {
    title: 'Horse-Rider Connection',
    color: '#14b8a6',
    keywords: ['co-regulation', 'cueing', 'connection', 'horse-rider'],
    description: 'These tools focus on strengthening the bond between you and your horse. By understanding co-regulation, improving communication through cueing, and building trust, you create a partnership that enhances both performance and the riding experience.',
    excludeKeywords: ['tapping', 'eft'],
  },
};

export default function CategoryDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams();
  const [strategies, setStrategies] = useState<Strategy[]>([]);
  const [loading, setLoading] = useState(true);
  const [playingId, setPlayingId] = useState<string | null>(null);

  const category = CATEGORIES[id as string];

  useEffect(() => {
    if (id && category) {
      fetchStrategies();
    }
  }, [id]);

  const fetchStrategies = async () => {
    try {
      const response = await api.get('/mental-strategies');
      const allStrategies = response.data;

      // Filter strategies by category keywords and exclude keywords
      const filtered = allStrategies.filter((s: Strategy) => {
        const categoryLower = s.category.toLowerCase();
        const nameLower = s.name.toLowerCase();
        const instructionsLower = s.instructions.toLowerCase();
        
        // Check if strategy matches category keywords
        const matchesCategory = category.keywords.some((keyword: string) =>
          categoryLower.includes(keyword.toLowerCase()) ||
          nameLower.includes(keyword.toLowerCase()) ||
          instructionsLower.includes(keyword.toLowerCase())
        );
        
        // Check if strategy should be excluded (e.g., tapping in non-tapping categories)
        const shouldExclude = category.excludeKeywords && category.excludeKeywords.some((keyword: string) =>
          categoryLower.includes(keyword.toLowerCase()) ||
          nameLower.includes(keyword.toLowerCase()) ||
          instructionsLower.includes(keyword.toLowerCase())
        );
        
        return matchesCategory && !shouldExclude;
      });

      // Remove duplicates by using a Map keyed by strategy ID
      const uniqueStrategies = Array.from(
        new Map(filtered.map((s: Strategy) => [s.id, s])).values()
      );

      setStrategies(uniqueStrategies);
    } catch (error) {
      console.error('Error fetching strategies:', error);
    } finally {
      setLoading(false);
    }
  };

  const cleanInstructions = (instructions: string): string => {
    // Remove "Micro Script:" and "Audio Script:" labels
    let cleaned = instructions
      .replace(/Micro Script:\s*/gi, '')
      .replace(/Audio Script:\s*/gi, '')
      .replace(/Coach:\s*/gi, '')
      .trim();
    
    // Split by double newlines to get paragraphs
    const paragraphs = cleaned.split(/\n\n+/);
    
    // If there are multiple paragraphs, skip the first one (description) and return the rest
    if (paragraphs.length > 1) {
      // Remove the first paragraph and join the rest
      return paragraphs.slice(1).join('\n\n').trim();
    }
    
    return cleaned;
  };

  const extractAudioScript = (instructions: string): string => {
    // Try to find audio script section
    const match = instructions.match(/Audio Script:\s*([\s\S]*?)(?:\n\n|$)/);
    if (match && match[1]) {
      return match[1].replace(/Coach:\s*/gi, '').trim();
    }
    
    // If no audio script found, try to find text after "Micro Script:"
    const microMatch = instructions.match(/Micro Script:\s*([\s\S]*?)(?:\n\n|Audio Script:|$)/);
    if (microMatch && microMatch[1]) {
      return microMatch[1].replace(/Coach:\s*/gi, '').trim();
    }
    
    return instructions.replace(/Coach:\s*/gi, '').trim();
  };

  const handlePlayAudio = (strategy: Strategy) => {
    if (playingId === strategy.id) {
      Speech.stop();
      setPlayingId(null);
      return;
    }

    const audioScript = extractAudioScript(strategy.instructions);
    setPlayingId(strategy.id);

    Speech.speak(audioScript, {
      language: 'en',
      pitch: 1.0,
      rate: 0.9,
      onDone: () => setPlayingId(null),
      onError: () => setPlayingId(null),
    });
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={category?.color || '#3b82f6'} />
          <Text style={styles.loadingText}>Loading tools...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!category) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
            <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
          </TouchableOpacity>
          <Text style={styles.title}>Category Not Found</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
        </TouchableOpacity>
        <Text style={styles.title}>{category.title}</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.scrollView}>
        {category.description && (
          <View style={styles.descriptionCard}>
            <Text style={styles.descriptionText}>{category.description}</Text>
            {id === 'tapping' && (
              <TouchableOpacity
                style={styles.guideButton}
                onPress={() => router.push('/tapping-guide' as any)}
              >
                <Ionicons name="book" size={20} color="#ffffff" />
                <Text style={styles.guideButtonText}>View Full Tapping Guide</Text>
              </TouchableOpacity>
            )}
          </View>
        )}
        
        <Text style={styles.subtitle}>{strategies.length} tools available</Text>

        {strategies.map((strategy) => (
          <View key={strategy.id} style={styles.toolCard}>
            <View style={styles.toolHeader}>
              <Text style={styles.toolName}>{strategy.name}</Text>
              <View style={styles.duration}>
                <Ionicons name="time-outline" size={16} color="#64748b" />
                <Text style={styles.durationText}>{strategy.duration_minutes} min</Text>
              </View>
            </View>

            <View style={styles.instructionsContainer}>
              <Text style={styles.instructionsText}>{cleanInstructions(strategy.instructions)}</Text>
            </View>

            <View style={styles.toolActions}>
              <TouchableOpacity
                style={[styles.audioButton, playingId === strategy.id && styles.audioButtonActive]}
                onPress={() => handlePlayAudio(strategy)}
              >
                <Ionicons
                  name={playingId === strategy.id ? 'stop-circle' : 'play-circle'}
                  size={20}
                  color="#ffffff"
                />
                <Text style={styles.audioButtonText}>
                  {playingId === strategy.id ? 'Stop Audio' : 'Play Audio'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        ))}

        {strategies.length === 0 && (
          <View style={styles.emptyContainer}>
            <Ionicons name="document-outline" size={64} color="#64748b" />
            <Text style={styles.emptyTitle}>No Tools Available</Text>
            <Text style={styles.emptyText}>Check back later for new tools in this category</Text>
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
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#64748b',
    fontSize: 16,
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
    color: '#1e293b',
  },
  placeholder: {
    width: 40,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  descriptionCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  descriptionText: {
    fontSize: 14,
    color: '#64748b',
    lineHeight: 22,
    marginBottom: 12,
  },
  guideButton: {
    flexDirection: 'row',
    backgroundColor: '#ec4899',
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 12,
  },
  guideButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  subtitle: {
    fontSize: 14,
    color: '#64748b',
    marginBottom: 24,
  },
  toolCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  toolHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  toolName: {
    flex: 1,
    fontSize: 18,
    fontWeight: '600',
    color: '#1e293b',
    marginRight: 12,
  },
  duration: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  durationText: {
    marginLeft: 4,
    fontSize: 14,
    color: '#64748b',
  },
  instructionsContainer: {
    marginBottom: 16,
  },
  instructionsText: {
    fontSize: 14,
    color: '#64748b',
    lineHeight: 22,
  },
  toolActions: {
    flexDirection: 'row',
  },
  audioButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  audioButtonActive: {
    backgroundColor: '#ef4444',
  },
  audioButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 64,
  },
  emptyTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 16,
  },
  emptyText: {
    fontSize: 14,
    color: '#64748b',
    marginTop: 8,
    textAlign: 'center',
  },
});

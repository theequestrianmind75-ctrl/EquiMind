import React, { useState } from 'react';
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
import { Ionicons } from '@expo/vector-icons';

const CATEGORIES = [
  {
    id: 'mindfulness',
    title: 'Mindfulness & Flow',
    description: 'Stay present and connected with your horse',
    icon: 'leaf',
    color: '#10b981',
    keywords: ['mindfulness'],
  },
  {
    id: 'breathing',
    title: 'Breathing / HRV',
    description: 'Regulate your nervous system through breath',
    icon: 'fitness',
    color: '#375B50',
    keywords: ['breathing', 'hrv'],
  },
  {
    id: 'grounding',
    title: 'Activation / Grounding',
    description: 'Connect to the present moment and your body',
    icon: 'footsteps',
    color: '#06b6d4',
    keywords: ['activation', 'grounding'],
  },
  {
    id: 'somatic',
    title: 'Somatic Reset',
    description: 'Body-based techniques for mental clarity',
    icon: 'body',
    color: '#8b5cf6',
    keywords: ['somatic', 'reset'],
  },
  {
    id: 'tapping',
    title: 'Tapping / EFT',
    description: 'Emotional Freedom Technique for stress relief',
    icon: 'hand-left',
    color: '#ec4899',
    keywords: ['tapping', 'eft'],
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
            {category.image ? (
              <Image source={category.image} style={styles.categoryImage} />
            ) : (
              <View style={[styles.iconCircle, { backgroundColor: category.color + '20' }]}>
                <Ionicons name={category.icon as any} size={32} color={category.color} />
              </View>
            )}
            <View style={styles.categoryContent}>
              <Text style={styles.categoryTitle}>{category.title}</Text>
              <Text style={styles.categoryDescription}>{category.description}</Text>
            </View>
            <Ionicons name="chevron-forward" size={24} color="#000000" />
          </TouchableOpacity>
        ))}

        <View style={styles.infoCard}>
          <Ionicons name="shield" size={24} color="#000000" />
          <Text style={styles.infoText}>
            These tools are personalized based on your pre-ride anxiety, confidence, and energy levels.
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
    paddingHorizontal: 24,
  },
  categoryCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  iconCircle: {
    width: 64,
    height: 64,
    borderRadius: 32,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 16,
  },
  categoryImage: {
    width: 64,
    height: 64,
    borderRadius: 32,
    marginRight: 16,
  },
  categoryContent: {
    flex: 1,
  },
  categoryTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1e293b',
    marginBottom: 4,
  },
  categoryDescription: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 20,
  },
  infoCard: {
    flexDirection: 'row',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginTop: 8,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  infoText: {
    flex: 1,
    fontSize: 13,
    color: '#000000',
    marginLeft: 12,
    lineHeight: 20,
  },
});
